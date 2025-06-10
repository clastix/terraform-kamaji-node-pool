# =============================================================================
# BOOTSTRAP TOKEN OUTPUTS
# =============================================================================

output "bootstrap_token" {
  description = "Bootstrap token details"
  value = {
    join_cmd = module.bootstrap_token.join_cmd
  }
  sensitive = true
}

# =============================================================================
# AZURE NODE POOLS OUTPUTS
# =============================================================================

output "node_pools" {
  description = "Azure node pools details"
  value = {
    for name, pool in module.azure_node_pools : name => {
      vmss_details            = pool.vmss_details
      autoscale_settings      = pool.autoscale_settings
      network_security_group  = pool.network_security_group
    }
  }
}

# =============================================================================
# CLUSTER INFORMATION
# =============================================================================

output "cluster_info" {
  description = "Cluster information"
  value = {
    tenant_cluster_name = var.tenant_cluster_name
    azure_location     = var.azure_location
    node_pools_count   = length(var.node_pools)
    node_pools_names   = [for pool in var.node_pools : pool.name]
  }
} 