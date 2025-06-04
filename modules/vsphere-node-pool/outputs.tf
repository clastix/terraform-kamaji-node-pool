# =============================================================================
# VM DETAILS
# =============================================================================

output "node_details" {
  description = "Virtual machine details"
  value = {
    for key, value in vsphere_virtual_machine.node :
    key => {
      name         = value.name
      ip_address   = value.default_ip_address
      uuid         = value.uuid
      power_state  = value.power_state
      cpu_cores    = value.num_cpus
      memory_mb    = value.memory
    }
  }
} 