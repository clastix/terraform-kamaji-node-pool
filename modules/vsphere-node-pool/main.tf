# =============================================================================
# LOCALS
# =============================================================================

locals {
  nodes = toset([for n in range(var.pool_size) : format("%s", n)])
}

# =============================================================================
# VSPHERE FOLDER
# =============================================================================

resource "vsphere_folder" "pool_folder" {
  path          = "${var.vsphere_root_folder}/${var.tenant_cluster_name}-${var.pool_name}-pool"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id

  lifecycle {
    ignore_changes = [
      datacenter_id
    ]
  }
}

# =============================================================================
# VIRTUAL MACHINES
# =============================================================================

resource "vsphere_virtual_machine" "node" {
  for_each = local.nodes

  lifecycle {
    ignore_changes = [
      resource_pool_id,
      clone[0].template_uuid,
      vapp[0].properties.user-data,
      tags
    ]
  }

  name             = "${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.pool_folder.path
  num_cpus         = var.node_cores
  memory           = var.node_memory
  guest_id         = var.node_guest
  firmware         = var.node_firmware
  scsi_type        = var.node_scsi_type
  enable_disk_uuid = true
  hardware_version = var.node_hardware_version

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    unit_number      = 0
    size             = var.node_disk_size
    thin_provisioned = var.node_disk_thin
  }

  clone {
    template_uuid = data.vsphere_content_library_item.item.id

    customize {
      dns_server_list = var.dns_resolvers

      linux_options {
        host_name    = "${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
        domain       = "clastix.local" # does not work but is needed by provider
        hw_clock_utc = true
        time_zone    = "Europe/Rome"
      }

      network_interface {
        ipv4_address = cidrhost(var.network_cidr, tonumber(each.key) + var.network_offset)
        ipv4_netmask = split("/", var.network_cidr)[1]
      }
      ipv4_gateway = var.network_gateway
    }
  }

  cdrom {
    client_device = true
  }

  extra_config = {
    "disk.enableUUID" = "TRUE"
  }

  vapp {
    properties = {
      hostname  = "H${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
      user-data = base64encode(templatefile("${path.module}/../templates/cloud-init/userdata.yml.tpl", {
        hostname       = "${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
        runcmd         = var.runcmd
        ssh_user       = var.ssh_user
        ssh_public_key = file(pathexpand(var.ssh_public_key_path))
      }))
    }
  }

  depends_on = [
    vsphere_folder.pool_folder,
    data.vsphere_datastore.datastore,
    data.vsphere_network.network,
    data.vsphere_resource_pool.pool,
    data.vsphere_content_library_item.item
  ]
}

# =============================================================================
# ANTI-AFFINITY RULES
# =============================================================================

/*
vSphere DRS needs a vSphere Enterprise Plus license. Disable the variable if you lack this license.
An anti-affinity rule distributes virtual machines across different hosts in a cluster, helping to avoid single points of failure.
*/

resource "vsphere_compute_cluster_vm_anti_affinity_rule" "node_anti_affinity_rule" {
  count               = var.vsphere_plus_license ? 1 : 0
  name                = "node_anti_affinity_rule"
  compute_cluster_id  = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_ids = [for key, value in vsphere_virtual_machine.node : value.id]
  
  lifecycle {
    ignore_changes = [
      compute_cluster_id
    ]
  }
}