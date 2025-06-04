# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
}

variable "tenant_kubeconfig_path" {
  description = "Path to the kubeconfig file for the tenant cluster"
  type        = string
  default     = "~/.kube/config"
}

# =============================================================================
# BOOTSTRAP CONFIGURATION
# =============================================================================

variable "yaki_url" {
  description = "URL to the YAKI script for node bootstrapping"
  type        = string
  default     = "https://goyaki.clastix.io"
}

# =============================================================================
# NODE POOL CONFIGURATION
# =============================================================================

variable "node_pools" {
  description = "List of AWS node pools with their configurations"
  type = list(object({
    name           = string
    size           = number
    node_disk_size = number
    instance_type  = string
    ami_id         = string
    min_size       = optional(number, 1)
    max_size       = optional(number, 9)
    disk_type      = optional(string, "gp3")
    public         = optional(bool, true)
  }))
}

# =============================================================================
# AWS CONFIGURATION
# =============================================================================

variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
  default     = "eu-south-1"
}

variable "aws_zones" {
  description = "AWS availability zones for worker nodes"
  type        = list(string)
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "aws_vpc_name" {
  description = "Name filter for the AWS VPC"
  type        = list(string)
  default     = ["kamaji"]
}

variable "tags" {
  description = "Tags applied to AWS resources"
  type        = map(string)
  default = {
    "ManagedBy" = "Clastix"
    "CreatedBy" = "Terraform"
  }
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for node access"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}