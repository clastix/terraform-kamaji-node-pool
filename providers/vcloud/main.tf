# =============================================================================
# PROVIDERS
# =============================================================================

# Configure the Kubernetes provider
provider "kubernetes" {
  # Path to the kubeconfig file for accessing the tenant cluster
  config_path = var.tenant_kubeconfig_path
}

# Configure the VMware Cloud Director Provider
provider "vcd" {
  user                 = var.vcd_username
  password             = var.vcd_password
  url                  = var.vcd_url
  org                  = var.vcd_org_name
  vdc                  = var.vcd_vdc_name
  allow_unverified_ssl = var.vcd_allow_insecure
  logging              = var.vcd_logging
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

module "vcloud_node_pools" {
  source = "../../modules/vcloud-node-pool"

  # Iterate over the list of node pools and call the module for each pool
  for_each = { for pool in var.node_pools : pool.name => pool }

  tenant_cluster_name = var.tenant_cluster_name # Name of the tenant cluster

  # Pool configuration
  pool_name = each.value.name
  pool_size = each.value.size

  # Node configuration
  node_memory               = each.value.node_memory
  node_cpus                 = each.value.node_cpus
  node_cpu_cores            = each.value.node_cpu_cores
  node_disk_size            = each.value.node_disk_size
  node_disk_storage_profile = each.value.node_disk_storage_profile

  # Network configuration
  vapp_network_name         = each.value.network_name
  vapp_network_adapter_type = each.value.network_adapter_type
  vapp_ip_allocation_mode   = each.value.ip_allocation_mode

  # Template configuration
  vapp_template_name = each.value.template_name

  # VMware Cloud Director configuration
  vcd_vdc_name         = var.vcd_vdc_name
  vcd_org_name         = var.vcd_org_name
  vcd_catalog_org_name = var.vcd_catalog_org_name
  vcd_catalog_name     = var.vcd_catalog_name
  vcd_logging          = var.vcd_logging

  # SSH configuration
  ssh_user             = var.ssh_user
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key_path  = var.ssh_public_key_path

  # Join command for bootstrapping nodes
  runcmd = module.bootstrap_token.join_cmd

  # Ensure the vcloud-node-pool module depends on the bootstrap-token module
  depends_on = [
    module.bootstrap_token
  ]

}