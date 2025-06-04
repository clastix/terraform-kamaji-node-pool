# Standard node pool summary output
output "node_pool_summary" {
  description = "Summary of node pool creation"
  value = {
    tenant_cluster_name = var.tenant_cluster_config.name
    kubeconfig_path     = var.tenant_cluster_config.kubeconfig_path
    pool_name           = var.node_pool_config.name
    pool_size           = var.node_pool_config.size
    min_size            = var.node_pool_config.min_size
    max_size            = var.node_pool_config.max_size
    ssh_user            = var.ssh_config.user
  }
}

# Standard success message
output "success_message" {
  description = "Success message for node pool creation"
  value = <<-EOT
    
    Kamaji Node Pool Successfully Created!
    
    Tenant Cluster: ${var.tenant_cluster_config.name}
    Pool Name: ${var.node_pool_config.name}
    Pool Size: ${var.node_pool_config.size}
    Kubeconfig: ${var.tenant_cluster_config.kubeconfig_path}
    
    To check node status:
    kubectl --kubeconfig ${var.tenant_cluster_config.kubeconfig_path} get nodes
    
  EOT
} 