# AWS Provider

Creates AWS Auto Scaling Groups for Kamaji node pools with automatic bootstrap token generation.

## Usage

1. **Configure variables**:
   ```bash
   cp main.auto.tfvars.sample main.auto.tfvars
   # Edit main.auto.tfvars with your settings
   ```

2. **Set AWS credentials**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   ```

3. **Deploy**:
   ```bash
   terraform init
   terraform apply
   ```

## Configuration Example

```hcl
# main.auto.tfvars
tenant_cluster_name    = "my-cluster"
tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
aws_region            = "us-east-1"
aws_zones             = ["us-east-1a", "us-east-1b"]

node_pools = [
  {
    name           = "workers"
    size           = 3
    instance_type  = "t3a.medium"
    ami_id         = "ami-0c02fb55956c7d316"
    node_disk_size = 20
    min_size       = 1
    max_size       = 5
  }
]
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tenant_cluster_name` | `string` | Required | Tenant cluster name |
| `tenant_kubeconfig_path` | `string` | `"~/.kube/config"` | Kubeconfig path |
| `yaki_url` | `string` | `"https://goyaki.clastix.io"` | YAKI bootstrap URL |
| `node_pools` | `list(object)` | Required | Node pool configurations |
| `aws_region` | `string` | `"eu-south-1"` | AWS region |
| `aws_zones` | `list(string)` | `["eu-south-1a", "eu-south-1b", "eu-south-1c"]` | Availability zones |
| `aws_vpc_name` | `list(string)` | `["kamaji"]` | VPC name filter |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |
| `tags` | `map(string)` | `{}` | Additional tags |

### Node Pool Configuration

Each node pool supports:
- `name` - Pool name (required)
- `size` - Number of instances (required)
- `instance_type` - EC2 instance type (default: "t3a.medium")
- `ami_id` - AMI ID (required)
- `node_disk_size` - Disk size in GB (default: 20)
- `min_size` - Minimum instances (default: 1)
- `max_size` - Maximum instances (default: 9)
- `disk_type` - EBS volume type (default: "gp3")
- `public` - Use public subnets (default: true)

## Outputs

- `node_pool_creation_summary` - Deployment summary
- `autoscaling_groups` - ASG details
- `bootstrap_token` - Bootstrap token info (sensitive)
- `cluster_info` - Cluster configuration
- `useful_commands` - Ready-to-use commands

## Requirements

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- Existing VPC with subnets
- Valid kubeconfig for Kamaji tenant cluster

## Finding AMI IDs

```bash
# Ubuntu 24.04 LTS (Noble)
aws ec2 describe-images --region us-east-1 \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
  --query 'Images|sort_by(@,&CreationDate)[-1].ImageId' \
  --output text

# Ubuntu 22.04 LTS (Jammy)
aws ec2 describe-images --region us-east-1 \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-jammy-22.04-amd64-server-*" \
  --query 'Images|sort_by(@,&CreationDate)[-1].ImageId' \
  --output text
```

