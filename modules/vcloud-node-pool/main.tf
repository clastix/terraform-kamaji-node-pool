# =============================================================================
# LOCALS
# =============================================================================

locals {
  nodes = toset([for n in range(var.pool_size) : format("%s", n)])
}

# =============================================================================
# VAPP CREATION
# =============================================================================

resource "vcd_vapp" "node_pool" {
  name        = "${var.tenant_cluster_name}-${var.pool_name}-pool"
  description = "vApp for ${var.tenant_cluster_name} cluster and ${var.pool_name} node pool"

  metadata_entry {
    key         = "provisioner"
    value       = "yaki"
    type        = "MetadataStringValue"
    user_access = "READWRITE"
    is_system   = false
  }
}

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

# Connect the dedicated routed network to vApp
resource "vcd_vapp_org_network" "network" {
  org                    = var.vcd_org_name
  vdc                    = var.vcd_vdc_name         
  vapp_name              = vcd_vapp.node_pool.name
  org_network_name       = var.vapp_network_name
  reboot_vapp_on_removal = true
  depends_on             = [vcd_vapp.node_pool]
}

# =============================================================================
# VIRTUAL MACHINES
# =============================================================================

resource "vcd_vapp_vm" "node_pool_vm" {
  for_each = local.nodes

  # Metadata
  metadata_entry {
    key         = "provisioner"
    value       = "yaki"
    type        = "MetadataStringValue"
    user_access = "READWRITE"
    is_system   = false
  }

  # Lifecycle management
  lifecycle {
    ignore_changes = [
      guest_properties.user-data,
      vapp_template_id,
      disk
    ]
  }

  # Basic VM configuration
  vapp_name     = vcd_vapp.node_pool.name
  name          = "${vcd_vapp.node_pool.name}-node-${format("%02s", each.key)}"
  computer_name = "${vcd_vapp.node_pool.name}-node-${format("%02s", each.key)}"

  # Cloud-init configuration
  guest_properties = {
    hostname  = "${vcd_vapp.node_pool.name}-node-${format("%02s", each.key)}"
    user-data = base64encode(templatefile("${path.module}/../templates/cloud-init/userdata.yml.tpl", {
      hostname       = "${vcd_vapp.node_pool.name}-node-${format("%02s", each.key)}",
      runcmd         = var.runcmd,
      ssh_user       = var.ssh_user,
      ssh_public_key = file(pathexpand(var.ssh_public_key_path))
    }))
  }

  # Template configuration
  vapp_template_id = data.vcd_catalog_vapp_template.vapp_template.id

  # Resource allocation
  memory                 = var.node_memory
  cpus                   = var.node_cpus
  cpu_cores              = var.node_cpu_cores
  cpu_hot_add_enabled    = false
  memory_hot_add_enabled = false

  # Network configuration
  network {
    type               = "org"
    name               = var.vapp_network_name
    adapter_type       = var.vapp_network_adapter_type
    ip_allocation_mode = var.vapp_ip_allocation_mode
    is_primary         = true
  }
  
  # Disk configuration
  override_template_disk {
    bus_type        = "paravirtual"
    size_in_mb      = var.node_disk_size
    bus_number      = 0
    unit_number     = 0
    storage_profile = var.node_disk_storage_profile
  }

  depends_on = [vcd_vapp.node_pool, vcd_vapp_org_network.network]
}
