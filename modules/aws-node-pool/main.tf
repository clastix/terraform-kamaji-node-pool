# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
  }
}

# =============================================================================
# IAM CONFIGURATION
# =============================================================================

# IAM Role and Policy for Node Pool
resource "aws_iam_policy" "node_policy" {
  name_prefix = "${var.tenant_cluster_name}-${var.pool_name}-"
  path        = "/"
  description = "Policy for role ${var.tenant_cluster_name}-${var.pool_name}"
  policy      = file("${path.module}/../templates/policies/aws-node-policy.json.tpl")
}

resource "aws_iam_role" "node_role" {
  name_prefix = "${var.tenant_cluster_name}-${var.pool_name}-"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "node-attach" {
  name       = "node-attachment-${var.tenant_cluster_name}-${var.pool_name}"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = aws_iam_policy.node_policy.arn
}

resource "aws_iam_instance_profile" "node_profile" {
  name_prefix = "${var.tenant_cluster_name}-${var.pool_name}-"
  role        = aws_iam_role.node_role.name
}

# =============================================================================
# SECURITY GROUP CONFIGURATION
# =============================================================================

# Security Group for Kubernetes Nodes
resource "aws_security_group" "kubernetes" {
  vpc_id      = data.aws_vpc.tenant.id
  name_prefix = "${var.tenant_cluster_name}-${var.pool_name}-"

  tags = merge(
    {
      "Name" = "${var.tenant_cluster_name}-${var.pool_name}"
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      description,
    ]
  }
}

# Allow outgoing connectivity
resource "aws_security_group_rule" "allow_all_outbound_from_kubernetes" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kubernetes.id
}

# Allow the security group members to talk with each other without restrictions
resource "aws_security_group_rule" "allow_cluster_crosstalk" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.kubernetes.id
  security_group_id        = aws_security_group.kubernetes.id
}

# Allow SSH access from your laptop
resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Change this to your IP for better security
  security_group_id = aws_security_group.kubernetes.id
}

# =============================================================================
# SSH KEY PAIR
# =============================================================================

# SSH Key Pair for Node Pool
resource "aws_key_pair" "keypair" {
  key_name_prefix = "${var.tenant_cluster_name}-${var.pool_name}-"
  public_key      = file(var.ssh_public_key_path)
}

# =============================================================================
# LAUNCH TEMPLATE
# =============================================================================

# Launch Template for Node Pool
resource "aws_launch_template" "nodes" {
  name_prefix   = "${var.tenant_cluster_name}-${var.pool_name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.keypair.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.node_profile.name
  }

  network_interfaces {
    associate_public_ip_address = var.public
    security_groups             = [aws_security_group.kubernetes.id]
    delete_on_termination       = true
  }

  user_data = data.cloudinit_config.node_cloud_init.rendered

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = var.node_disk_type
      volume_size           = var.node_disk_size
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        "Name" = "${var.tenant_cluster_name}-${var.pool_name}"
      },
      var.tags,
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# =============================================================================
# AUTO SCALING GROUP
# =============================================================================

resource "aws_autoscaling_group" "nodes" {
  vpc_zone_identifier = data.aws_subnets.tenant_subnets.ids

  name_prefix      = "${var.tenant_cluster_name}-${var.pool_name}-"
  max_size         = var.pool_max_size
  min_size         = var.pool_min_size
  desired_capacity = var.pool_size

  launch_template {
    id      = aws_launch_template.nodes.id
    version = "$Latest"
  }

  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = var.instance_refresh_min_healthy_percentage
        instance_warmup        = var.instance_refresh_warmup
      }
      triggers = ["tag"]
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  tag {
    key                 = "Name"
    value               = "${var.tenant_cluster_name}-${var.pool_name}"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_launch_template.nodes,
    aws_security_group.kubernetes,
    aws_security_group_rule.allow_all_outbound_from_kubernetes,
    aws_security_group_rule.allow_cluster_crosstalk,
    aws_security_group_rule.allow_ssh_inbound
  ]
}


