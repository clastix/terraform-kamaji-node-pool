# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

output "deployment_summary" {
  description = "Summary of the node pool deployment"
  value       = <<-EOT

✅ Kamaji Node Pools Deployed Successfully

Cluster:    ${var.tenant_cluster_name}
vCenter:    ${var.vsphere_server}
Datacenter: ${var.vsphere_datacenter}

Node Pools:
${join("\n", [for pool_name, pool in module.vsphere_node_pools : format("  • %s: %d nodes (%d MB RAM)", pool_name, length(pool.node_details), length(pool.node_details) > 0 ? values(pool.node_details)[0].memory_mb : 0)])}

VMs Created:
${join("\n", [for pool_name, pool in module.vsphere_node_pools : join("\n", [for vm in values(pool.node_details) : format("  • %s: %s", vm.name, vm.ip_address)])])}

Next Steps:
  kubectl --kubeconfig ${var.tenant_kubeconfig_path} get nodes

EOT
}

# =============================================================================
# NODE DETAILS
# =============================================================================

output "node_pools" {
  description = "Node pool details"
  value = {
    for pool_name, pool in module.vsphere_node_pools : pool_name => {
      vms = [
        for vm in values(pool.node_details) : {
          name         = vm.name
          ip_address   = vm.ip_address
          uuid         = vm.uuid
          memory_mb    = vm.memory_mb
          cpu_cores    = vm.cpu_cores
          power_state  = vm.power_state
        }
      ]
    }
  }
}

# =============================================================================
# CLUSTER INFO
# =============================================================================

output "cluster_info" {
  description = "Cluster configuration"
  value = {
    name               = var.tenant_cluster_name
    kubeconfig         = var.tenant_kubeconfig_path
    vsphere_server     = var.vsphere_server
    vsphere_datacenter = var.vsphere_datacenter
    total_pools        = length(var.node_pools)
    total_nodes        = sum([for pool in var.node_pools : pool.size])
  }
} 