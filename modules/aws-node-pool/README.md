# AWS Node Pool Module

Creates AWS Auto Scaling Groups for Kubernetes worker nodes in Kamaji tenant clusters.

## Usage

```hcl
module "aws_node_pool" {
  source = "../../modules/aws-node-pool"

  # Cluster configuration
  tenant_cluster_name = "my-cluster"
  pool_name          = "workers"
  pool_size          = 3

  # Instance configuration
  instance_type  = "t3a.large"
  ami_id         = "ami-06147ccec7237575f"
  node_disk_size = 50

  # AWS configuration
  aws_region   = "us-west-2"
  aws_zones    = ["us-west-2a", "us-west-2b"]
  aws_vpc_name = ["my-vpc"]

  # SSH configuration
  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  # Bootstrap command
  runcmd = "kubeadm join cluster-api:6443 --token abc123.xyz789"
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tenant_cluster_name` | `string` | Required | Tenant cluster name |
| `pool_name` | `string` | Required | Node pool name |
| `pool_size` | `number` | `3` | Number of instances |
| `pool_min_size` | `number` | `1` | Minimum instances |
| `pool_max_size` | `number` | `10` | Maximum instances |
| `instance_type` | `string` | `"t3a.medium"` | EC2 instance type |
| `ami_id` | `string` | Required | AMI ID for instances |
| `node_disk_size` | `number` | `20` | EBS volume size (GB) |
| `node_disk_type` | `string` | `"gp3"` | EBS volume type |
| `aws_region` | `string` | Required | AWS region |
| `aws_zones` | `list(string)` | Required | Availability zones |
| `aws_vpc_name` | `list(string)` | Required | VPC name filter |
| `public` | `bool` | `true` | Use public subnets |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |
| `runcmd` | `string` | Required | Bootstrap command |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

- `autoscaling_group_details` - Auto Scaling Group information
- `launch_template_details` - Launch template configuration
- `security_group_details` - Security group information
- `instance_details` - Instance configuration details
- `deployment_summary` - Human-readable deployment summary

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Existing VPC with subnets
- Ubuntu AMI with cloud-init support 