# =============================================================================
# VM DETAILS
# =============================================================================

output "vm_details" {
  description = "Virtual machine details"
  value = [
    for node in proxmox_vm_qemu.node : {
      name         = node.name
      ip_address   = node.default_ipv4_address
      memory_mb    = node.memory
      cpu_cores    = node.cores
      cpu_sockets  = node.sockets
      state        = node.vm_state
    }
  ]
} 