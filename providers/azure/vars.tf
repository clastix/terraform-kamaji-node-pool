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
  description = "List of Azure node pools with their configurations"
  type = list(object({
    name                   = string
    size                   = number
    node_disk_size         = number
    vm_size                = string
    min_size               = optional(number, 1)
    max_size               = optional(number, 9)
    node_disk_type         = optional(string, "Premium_LRS")
    assign_public_ip       = optional(bool, true)
    enable_autoscaling     = optional(bool, false)
    scale_out_cpu_threshold = optional(number, 75)
    scale_in_cpu_threshold  = optional(number, 25)
    enable_automatic_instance_repair = optional(bool, false)
    automatic_instance_repair_grace_period = optional(string, "PT30M")
    upgrade_mode          = optional(string, "Manual")
  }))
}

# =============================================================================
# AZURE CONFIGURATION
# =============================================================================

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_location" {
  description = "Azure region where resources will be created"
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
  description = "CIDR block for the Azure subnet"
  type        = string
  default     = "10.10.10.0/24"
}

# =============================================================================
# VM IMAGE CONFIGURATION
# =============================================================================

variable "vm_image_publisher" {
  description = "Azure VM image publisher"
  type        = string
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "Azure VM image offer"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "vm_image_sku" {
  description = "Azure VM image SKU"
  type        = string
  default     = "server"
}

variable "vm_image_version" {
  description = "Azure VM image version"
  type        = string
  default     = "latest"
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

# =============================================================================
# TAGS
# =============================================================================

variable "tags" {
  description = "Tags applied to Azure resources"
  type        = map(string)
  default = {
    "ManagedBy" = "Clastix"
    "CreatedBy" = "Terraform"
  }
} 