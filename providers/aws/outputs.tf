# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

output "deployment_summary" {
  description = "Summary of the node pool deployment"
  value       = <<-EOT

✅ Kamaji Node Pools Deployed Successfully

Cluster: ${var.tenant_cluster_name}
Region:  ${var.aws_region}
Zones:   ${join(", ", var.aws_zones)}

Node Pools:
${join("\n", [for pool_name, pool in module.aws_node_pools : format("  • %s: %d nodes (%s)", pool_name, pool.autoscaling_group_details.desired_capacity, pool.launch_template_details.instance_type)])}

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
    for pool_name, pool in module.aws_node_pools : pool_name => {
      name            = pool.autoscaling_group_details.name
      desired_size    = pool.autoscaling_group_details.desired_capacity
      min_size        = pool.autoscaling_group_details.min_size
      max_size        = pool.autoscaling_group_details.max_size
      instance_type   = pool.launch_template_details.instance_type
      ami_id          = pool.launch_template_details.ami_id
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
    region         = var.aws_region
    zones          = var.aws_zones
    total_pools    = length(var.node_pools)
    total_nodes    = sum([for pool in module.aws_node_pools : pool.autoscaling_group_details.desired_capacity])
  }
} 