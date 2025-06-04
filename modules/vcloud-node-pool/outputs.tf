# =============================================================================
# VAPP DETAILS
# =============================================================================

output "vapp_details" {
  description = "vApp information"
  value = {
    name = vcd_vapp.node_pool.name
    id   = vcd_vapp.node_pool.id
  }
}

# =============================================================================
# VM DETAILS
# =============================================================================

output "virtual_machines" {
  description = "Virtual machine details"
  value = {
    for vm_key, vm in vcd_vapp_vm.node_pool_vm : vm_key => {
      name          = vm.name
      computer_name = vm.computer_name
      memory        = vm.memory
      cpus          = vm.cpus
      cpu_cores     = vm.cpu_cores
      network = length(vm.network) > 0 ? {
        ip  = tolist(vm.network)[0].ip
        mac = tolist(vm.network)[0].mac
      } : null
    }
  }
} 