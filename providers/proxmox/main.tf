# =============================================================================
# PROVIDERS
# =============================================================================

provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_parallel     = 1
  pm_tls_insecure = true
  pm_log_enable   = false
  pm_timeout      = 600
}

# =============================================================================
# BOOTSTRAP TOKEN
# =============================================================================

module "bootstrap_token" {
  source          = "../../modules/bootstrap-token"
  kubeconfig_path = var.tenant_kubeconfig_path
  yaki_url        = var.yaki_url
}

# =============================================================================
# NODE POOLS
# =============================================================================

module "proxmox_node_pools" {
  source = "../../modules/proxmox-node-pool"

  for_each = { for pool in var.node_pools : pool.name => pool }

  # Cluster Configuration
  tenant_cluster_name = var.tenant_cluster_name
  pool_name           = each.value.name
  pool_size           = each.value.size
  runcmd              = module.bootstrap_token.join_cmd

  # Network Configuration
  network_cidr    = each.value.network_cidr
  network_gateway = each.value.network_gateway
  network_offset  = each.value.network_offset
  network_bridge  = var.network_bridge
  network_model   = var.network_model
  nameserver      = var.nameserver
  search_domain   = var.search_domain

  # VM Configuration
  vms_state     = each.value.vms_state
  vms_agent     = each.value.vms_agent
  vms_memory    = each.value.vms_memory
  vms_sockets   = each.value.vms_sockets
  vms_cores     = each.value.vms_cores
  vms_vcpus     = each.value.vms_vcpus
  vms_boot      = each.value.vms_boot
  vms_scsihw    = each.value.vms_scsihw
  vms_disk_size = each.value.vms_disk_size
  vms_template  = each.value.vms_template

  # Proxmox Configuration
  proxmox_host     = var.proxmox_host
  proxmox_node     = var.proxmox_node
  proxmox_api_url  = var.proxmox_api_url
  proxmox_user     = var.proxmox_user
  proxmox_password = var.proxmox_password
  storage_disk     = var.storage_disk

  # SSH Configuration
  ssh_user             = var.ssh_user
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key_path  = var.ssh_public_key_path

  depends_on = [module.bootstrap_token]
}
