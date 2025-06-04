# AWS Example

Example configuration for deploying Kamaji node pools on AWS using Auto Scaling Groups.

## Usage

1. **Copy and customize**:
   ```bash
   cp example.tf main.tf
   # Edit main.tf with your configuration
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

## Configuration

Update the following in `main.tf`:
- `tenant_cluster_name` - Your Kamaji tenant cluster name
- `kubeconfig_path` - Path to your tenant cluster kubeconfig
- `aws_region` and `aws_zones` - Your target AWS region and zones
- `ami_id` - Ubuntu AMI ID for your region
- Node pool specifications (instance type, size, etc.)

## Requirements

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- Existing VPC with subnets
- Valid kubeconfig for Kamaji tenant cluster 