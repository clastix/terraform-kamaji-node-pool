# Example: AWS Provider Usage
# This example shows how to use the AWS provider wrapper

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

# Use the AWS provider module
module "aws_kamaji_node_pools" {
  source = "../../providers/aws"

  # Cluster configuration
  tenant_cluster_name    = "my-aws-cluster"
  tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
  yaki_url              = "https://goyaki.clastix.io"

  # Node pools configuration
  node_pools = [
    {
      name           = "workers"
      size           = 3
      min_size       = 2
      max_size       = 10
      node_disk_size = 50
      disk_type      = "gp3"
      instance_type  = "t3a.large"
      ami_id         = "ami-06147ccec7237575f"
      public         = true
    }
  ]

  # AWS configuration
  aws_region = var.aws_region
  aws_zones  = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
  aws_vpc_name = ["kamaji"]
  tags = {
    "ManagedBy"   = "Terraform"
    "Environment" = "production"
    "Provider"    = "AWS"
  }

  # SSH configuration
  ssh_user            = "ubuntu"
  ssh_public_key_path = "~/.ssh/id_rsa.pub"
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-south-1"
}

variable "tenant_kubeconfig_path" {
  description = "Path to tenant cluster kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

# Outputs
output "deployment_summary" {
  description = "Deployment summary"
  value       = module.aws_kamaji_node_pools.deployment_summary
}

output "autoscaling_groups" {
  description = "Auto Scaling Group details"
  value       = module.aws_kamaji_node_pools.autoscaling_groups
} 