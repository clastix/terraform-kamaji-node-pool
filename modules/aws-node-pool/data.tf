# =============================================================================
# DATA SOURCES
# =============================================================================

data "aws_vpc" "tenant" {
  filter {
    name   = "tag:Name"
    values = var.aws_vpc_name
  }
}

data "aws_subnets" "tenant_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.tenant.id]
  }
  
  filter {
    name   = "availability-zone"
    values = var.aws_zones 
  }
  
}

# =============================================================================
# CLOUD-INIT CONFIGURATION
# =============================================================================

data "cloudinit_config" "node_cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../templates/cloud-init/userdata.yml.tpl", {
      hostname       = ""
      runcmd         = var.runcmd
      ssh_user       = var.ssh_user
      ssh_public_key = file(pathexpand(var.ssh_public_key_path))
    })
  }
}

