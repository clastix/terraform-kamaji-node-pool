# =============================================================================
# PROVIDERS
# =============================================================================

# Configure the Kubernetes provider
provider "kubernetes" {
  # Path to the kubeconfig file for accessing the tenant cluster
  config_path = var.tenant_kubeconfig_path
}

# Configure the vSphere provider
provider "vsphere" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

# =============================================================================
# BOOTSTRAP TOKEN
# =============================================================================

# Call the shared bootstrap-token module to generate the join command
module "bootstrap_token" {
  source = "../../modules/bootstrap-token"

  kubeconfig_path = var.tenant_kubeconfig_path
  yaki_url        = var.yaki_url
}

# =============================================================================
# NODE POOLS
# =============================================================================

# Iterate over the list of node pools and call the vsphere-node-pool module for each pool
module "vsphere_node_pools" {
  source = "../../modules/vsphere-node-pool"
  
  # Iterate over the node pools defined in the variables
  for_each = { for pool in var.node_pools : pool.name => pool }

  # Tenant Cluster Configuration
  tenant_cluster_name = var.tenant_cluster_name

  # Pool Configuration
  pool_name = each.value.name
  pool_size = each.value.size

  # Node Configuration
  node_cores     = each.value.node_cores
  node_memory    = each.value.node_memory
  node_guest     = each.value.node_guest
  node_disk_size = each.value.node_disk_size

  # Network Configuration
  network_cidr    = each.value.network_cidr
  network_gateway = each.value.network_gateway
  network_offset  = each.value.network_offset
  dns_resolvers   = var.dns_resolvers

  # SSH Configuration
  ssh_user             = var.ssh_user
  ssh_public_key_path  = var.ssh_public_key_path
  ssh_private_key_path = var.ssh_private_key_path

  # vSphere Configuration
  vsphere_plus_license         = var.vsphere_plus_license
  vsphere_username             = var.vsphere_username
  vsphere_password             = var.vsphere_password
  vsphere_server               = var.vsphere_server
  vsphere_datacenter           = var.vsphere_datacenter
  vsphere_compute_cluster      = var.vsphere_compute_cluster
  vsphere_datastore            = var.vsphere_datastore
  vsphere_resource_pool        = var.vsphere_resource_pool
  vsphere_network              = var.vsphere_network
  vsphere_content_library      = var.vsphere_content_library
  vsphere_content_library_item = var.vsphere_content_library_item
  vsphere_root_folder          = var.vsphere_root_folder

  # Bootstrap Configuration
  runcmd = module.bootstrap_token.join_cmd

  # Dependencies
  depends_on = [module.bootstrap_token]
}