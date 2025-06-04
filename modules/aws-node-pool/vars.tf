# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

# Name of the tenant cluster
variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
  default     = "charlie"
}

# =============================================================================
# POOL CONFIGURATION
# =============================================================================

variable "runcmd" {
  description = "Command to run on the node at first boot time"
  type        = string
  default     = "echo 'Hello, World!'"
}

variable "pool_name" {
  description = "Name of the node pool"
  type        = string
  default     = "default"
}

variable "pool_size" {
  description = "The size of the node pool"
  type        = number
  default     = 3
}

variable "pool_min_size" {
  description = "The minimum size of the node pool"
  type        = number
  default     = 1
}

variable "pool_max_size" {
  description = "The maximum size of the node pool"
  type        = number
  default     = 9
}

# =============================================================================
# AWS CONFIGURATION
# =============================================================================

variable "aws_region" {
  description = "Region where resources are created"
  default     = "eu-south-1"
}

variable "aws_zones" {
  type        = list(string)
  description = "AWS AZs where worker nodes should be created"
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "instance_type" {
  description = "Type of instance for workers"
  default     = "t3a.medium"
}

variable "ami_id" {
  description = "AMI ID to use for the instances."
  type        = string
}

variable "aws_vpc_name" {
  description = "The name of the AWS VPC to filter"
  type        = list(string)
  default     = ["kamaji"]
}

variable "public" {
  description = "Whether to associate a public IP address with instances"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags used for AWS resources"
  type        = map(string)
  default = {
    "ManagedBy" = "Clastix"
    "CreatedBy" = "Terraform"
  }
}

# =============================================================================
# NODE CONFIGURATION
# =============================================================================

variable "node_disk_size" {
  description = "Disk size for each node in GB"
  type        = number
  default     = 20
}

variable "node_disk_type" {
  description = "EBS volume type for each node (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for the nodes"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# =============================================================================
# INSTANCE REFRESH CONFIGURATION
# =============================================================================

variable "enable_instance_refresh" {
  description = "Enable automatic instance refresh when launch template changes"
  type        = bool
  default     = true
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum percentage of instances that must remain healthy during instance refresh"
  type        = number
  default     = 50
}

variable "instance_refresh_warmup" {
  description = "Number of seconds until a newly launched instance is configured and ready to use"
  type        = number
  default     = 300
}