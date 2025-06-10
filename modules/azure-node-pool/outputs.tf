# =============================================================================
# VIRTUAL MACHINE SCALE SET
# =============================================================================

output "vmss_details" {
  description = "Virtual Machine Scale Set details"
  value = {
    name             = azurerm_linux_virtual_machine_scale_set.nodes.name
    id               = azurerm_linux_virtual_machine_scale_set.nodes.id
    resource_group   = azurerm_linux_virtual_machine_scale_set.nodes.resource_group_name
    location         = azurerm_linux_virtual_machine_scale_set.nodes.location
    instances        = azurerm_linux_virtual_machine_scale_set.nodes.instances
    vm_size          = azurerm_linux_virtual_machine_scale_set.nodes.sku
  }
}

# =============================================================================
# AUTOSCALING SETTINGS
# =============================================================================

output "autoscale_settings" {
  description = "Autoscale settings details"
  value = var.enable_autoscaling ? {
    name               = azurerm_monitor_autoscale_setting.nodes[0].name
    id                 = azurerm_monitor_autoscale_setting.nodes[0].id
    min_size           = var.pool_min_size
    max_size           = var.pool_max_size
    target_resource_id = azurerm_monitor_autoscale_setting.nodes[0].target_resource_id
  } : null
}

# =============================================================================
# NETWORK SECURITY GROUP
# =============================================================================

output "network_security_group" {
  description = "Network Security Group details"
  value = {
    name                = azurerm_network_security_group.kubernetes.name
    id                  = azurerm_network_security_group.kubernetes.id
    resource_group_name = azurerm_network_security_group.kubernetes.resource_group_name
  }
} 