# =============================================================================
# PROVIDERS
# =============================================================================

# Configure the Kubernetes provider
provider "kubernetes" {
  # Path to the kubeconfig file for accessing the tenant cluster
  config_path = var.tenant_kubeconfig_path
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

# =============================================================================
# BOOTSTRAP TOKEN
# =============================================================================

# Call the shared bootstrap-token module to generate the join command
module "bootstrap_token" {
  source          = "../../modules/bootstrap-token" # Updated to use shared module
  kubeconfig_path = var.tenant_kubeconfig_path      # Pass the kubeconfig path to the module
  yaki_url        = var.yaki_url                    # Pass the YAKI URL to the module
}

# =============================================================================
# NODE POOLS
# =============================================================================

module "azure_node_pools" {
  source = "../../modules/azure-node-pool" # Updated path to the azure-node-pool module

  # Iterate over the list of node pools and call the module for each pool
  for_each = { for pool in var.node_pools : pool.name => pool }

  # Tenant cluster configuration
  tenant_cluster_name = var.tenant_cluster_name

  # Pool configuration
  pool_name     = each.value.name
  pool_size     = each.value.size
  pool_min_size = each.value.min_size
  pool_max_size = each.value.max_size

  # Node configuration
  node_disk_size = each.value.node_disk_size
  node_disk_type = each.value.node_disk_type

  # Azure configuration
  azure_location                = var.azure_location
  azure_resource_group_name     = var.azure_resource_group_name
  azure_vnet_name              = var.azure_vnet_name
  azure_subnet_name            = var.azure_subnet_name
  vnet_subnet_address_prefix   = var.vnet_subnet_address_prefix
  vm_size                      = each.value.vm_size
  assign_public_ip             = each.value.assign_public_ip
  vm_image_publisher           = var.vm_image_publisher
  vm_image_offer              = var.vm_image_offer
  vm_image_sku                = var.vm_image_sku
  vm_image_version            = var.vm_image_version
  tags                        = var.tags

  # SSH configuration
  ssh_user            = var.ssh_user
  ssh_public_key_path = var.ssh_public_key_path

  # Autoscaling configuration
  enable_autoscaling           = each.value.enable_autoscaling
  scale_out_cpu_threshold      = each.value.scale_out_cpu_threshold
  scale_in_cpu_threshold       = each.value.scale_in_cpu_threshold

  # Instance repair configuration
  enable_automatic_instance_repair = each.value.enable_automatic_instance_repair
  automatic_instance_repair_grace_period = each.value.automatic_instance_repair_grace_period
  upgrade_mode                 = each.value.upgrade_mode

  # Join command for bootstrapping nodes
  runcmd = module.bootstrap_token.join_cmd

  # Ensure the azure-node-pool module depends on the bootstrap-token module
  depends_on = [
    module.bootstrap_token
  ]
} 