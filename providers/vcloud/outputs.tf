# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

output "deployment_summary" {
  description = "Summary of the node pool deployment"
  value       = <<-EOT

✅ Kamaji Node Pools Deployed Successfully

Cluster:      ${var.tenant_cluster_name}
Organization: ${var.vcd_org_name}
VDC:          ${var.vcd_vdc_name}

Node Pools:
${join("\n", [for pool_name, pool in module.vcloud_node_pools : format("  • %s: %d nodes (%d MB RAM)", pool_name, length(pool.virtual_machines), length(pool.virtual_machines) > 0 ? values(pool.virtual_machines)[0].memory : 0)])}

vApps Created:
${join("\n", [for pool_name, pool in module.vcloud_node_pools : format("  • %s: %s", pool_name, pool.vapp_details.name)])}

VMs Created:
${join("\n", [for pool_name, pool in module.vcloud_node_pools : join("\n", [for vm in values(pool.virtual_machines) : format("  • %s", vm.computer_name)])])}

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
    for pool_name, pool in module.vcloud_node_pools : pool_name => {
      vapp_name = pool.vapp_details.name
      vapp_id   = pool.vapp_details.id
      vms = [
        for vm in values(pool.virtual_machines) : {
          name          = vm.name
          computer_name = vm.computer_name
          memory        = vm.memory
          cpus          = vm.cpus
          cpu_cores     = vm.cpu_cores
          network_ip    = vm.network != null ? vm.network.ip : null
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
    vcd_org_name   = var.vcd_org_name
    vcd_vdc_name   = var.vcd_vdc_name
    total_pools    = length(var.node_pools)
    total_nodes    = sum([for pool in var.node_pools : pool.size])
  }
} 