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
# AZURE CONFIGURATION
# =============================================================================

variable "azure_location" {
  description = "Azure region where resources are created"
  type        = string
  default     = "italynorth"
}

variable "azure_resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "kamaji"
}

variable "azure_vnet_name" {
  description = "Name of the Azure virtual network"
  type        = string
  default     = "kamaji-vnet"
}

variable "azure_subnet_name" {
  description = "Name of the Azure subnet"
  type        = string
  default     = "kamaji-subnet"
}

variable "vnet_subnet_address_prefix" {
  description = "Address prefix for the subnet (used for security group rules)"
  type        = string
  default     = "10.10.10.0/24"
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "assign_public_ip" {
  description = "Whether to assign public IP addresses to VMs"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags used for Azure resources"
  type        = map(string)
  default = {
    "ManagedBy" = "Clastix"
    "CreatedBy" = "Terraform"
  }
}

# =============================================================================
# VM IMAGE CONFIGURATION
# =============================================================================

variable "vm_image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "vm_image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "server"
}

variable "vm_image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

# =============================================================================
# NODE CONFIGURATION
# =============================================================================

variable "node_disk_size" {
  description = "Disk size for each node in GB"
  type        = number
  default     = 30
}

variable "node_disk_type" {
  description = "Storage account type for each node (Standard_LRS, Premium_LRS)"
  type        = string
  default     = "Premium_LRS"
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
# AUTO SCALING CONFIGURATION
# =============================================================================

variable "enable_autoscaling" {
  description = "Enable automatic scaling based on CPU metrics"
  type        = bool
  default     = true
}

variable "scale_out_cpu_threshold" {
  description = "CPU threshold percentage to trigger scale out"
  type        = number
  default     = 75
}

variable "scale_in_cpu_threshold" {
  description = "CPU threshold percentage to trigger scale in"
  type        = number
  default     = 25
}

# =============================================================================
# INSTANCE REPAIR CONFIGURATION
# =============================================================================

variable "enable_automatic_instance_repair" {
  description = "Enable automatic instance repair for failed VMs"
  type        = bool
  default     = true
}

variable "automatic_instance_repair_grace_period" {
  description = "Grace period for automatic instance repair (in minutes)"
  type        = string
  default     = "PT30M"
}

variable "upgrade_mode" {
  description = "Upgrade mode for the scale set (Manual, Automatic, Rolling)"
  type        = string
  default     = "Manual"
} 