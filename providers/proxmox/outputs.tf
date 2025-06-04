# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

output "deployment_summary" {
  description = "Summary of the node pool deployment"
  value       = <<-EOT

✅ Kamaji Node Pools Deployed Successfully

Cluster: ${var.tenant_cluster_name}
Host:    ${var.proxmox_host}
Node:    ${var.proxmox_node}

Node Pools:
${join("\n", [for pool_name, pool in module.proxmox_node_pools : format("  • %s: %d nodes (%d MB RAM)", pool_name, length(pool.vm_details), length(pool.vm_details) > 0 ? pool.vm_details[0].memory_mb : 0)])}

VMs Created:
${join("\n", [for pool_name, pool in module.proxmox_node_pools : join("\n", [for vm in pool.vm_details : format("  • %s: %s", vm.name, vm.ip_address)])])}

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
    for pool_name, pool in module.proxmox_node_pools : pool_name => {
      vms = [
        for vm in pool.vm_details : {
          name       = vm.name
          ip_address = vm.ip_address
          memory_mb  = vm.memory_mb
          cpu_cores  = vm.cpu_cores
          state      = vm.state
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
    name           = var.tenant_cluster_name
    kubeconfig     = var.tenant_kubeconfig_path
    proxmox_host   = var.proxmox_host
    proxmox_node   = var.proxmox_node
    total_pools    = length(var.node_pools)
    total_nodes    = sum([for pool in var.node_pools : pool.size])
  }
} 