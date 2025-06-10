# =============================================================================
# AZURE KAMAJI NODE POOL EXAMPLE
# =============================================================================
#
# This example demonstrates multi-pool Azure node configuration with both
# manual and automatic scaling options:
#
# SCALING MODES:
# - enable_autoscaling = true:  Azure manages scaling based on CPU metrics
# - enable_autoscaling = false: Terraform directly controls pool_size
#
# For manual control, set enable_autoscaling = false and adjust pool_size
# in your configuration files.
#
# =============================================================================

# Example: Azure Provider Usage
# This example shows how to use the Azure provider wrapper

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

# Use the Azure provider module
module "azure_kamaji_node_pools" {
  source = "../../providers/azure"

  # Cluster configuration
  tenant_cluster_name    = "my-azure-cluster"
  tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
  yaki_url              = "https://goyaki.clastix.io"

  # Node pools configuration
  node_pools = [
    {
      name           = "default"
      size           = 3
      min_size       = 2
      max_size       = 10
      node_disk_size = 50
      node_disk_type = "Premium_LRS"
      vm_size        = "Standard_D2s_v3"
      assign_public_ip = true
      enable_autoscaling = false
      scale_out_cpu_threshold = 75
      scale_in_cpu_threshold  = 25
      enable_automatic_instance_repair = false
      automatic_instance_repair_grace_period = "PT30M"
      upgrade_mode = "Manual"
    },
    {
      name           = "system"
      size           = 2
      min_size       = 1
      max_size       = 5
      node_disk_size = 100
      node_disk_type = "Premium_LRS"
      vm_size        = "Standard_D4s_v3"
      assign_public_ip = false
      enable_autoscaling = true
      scale_out_cpu_threshold = 80
      scale_in_cpu_threshold  = 30
      enable_automatic_instance_repair = true
      automatic_instance_repair_grace_period = "PT15M"
      upgrade_mode = "Automatic"
    }
  ]

  # Azure configuration
  azure_subscription_id      = var.azure_subscription_id
  azure_location            = var.azure_location
  azure_resource_group_name = "kamaji"
  azure_vnet_name           = "kamaji-vnet"
  azure_subnet_name         = "kamaji-subnet"
  vnet_subnet_address_prefix = "10.10.10.0/24"
  tags = {
    "ManagedBy"   = "Terraform"
    "Environment" = "production"
    "Provider"    = "Azure"
  }

  # SSH configuration
  ssh_user            = "ubuntu"
  ssh_public_key_path = "~/.ssh/id_rsa.pub"
}

# Variables
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
  default     = "italynorth"
}

variable "tenant_kubeconfig_path" {
  description = "Path to tenant cluster kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

# Outputs
output "cluster_info" {
  description = "Cluster information"
  value       = module.azure_kamaji_node_pools.cluster_info
}

output "node_pools" {
  description = "Node pools details"
  value       = module.azure_kamaji_node_pools.node_pools
} 