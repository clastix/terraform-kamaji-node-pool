# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_providers {
    # https://github.com/telmate/terraform-provider-proxmox
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

# =============================================================================
# LOCALS
# =============================================================================

locals {
  nodes         = toset([for n in range(var.pool_size) : format("%s", n)])
  template_path = "${path.module}/../templates/cloud-init/userdata.yml.tpl"
}

# =============================================================================
# CLOUD-INIT FILE GENERATION
# =============================================================================

resource "local_file" "cloud_init_user_data_file" {
  for_each = local.nodes
  
  content = templatefile(local.template_path, {
    hostname       = "${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
    ssh_user       = var.ssh_user
    ssh_public_key = file(pathexpand(var.ssh_public_key_path))
    runcmd         = var.runcmd
  })
  
  filename = "${path.module}/files/${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}.cfg"
}

# =============================================================================
# CLOUD-INIT FILE TRANSFER
# =============================================================================

resource "null_resource" "cloud_init_config" {
  for_each = local.nodes
  
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${var.ssh_private_key_path}")
    host        = var.proxmox_host
    timeout     = "30s"
  }

  # Ensure snippets directory exists
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /var/lib/vz/snippets",
      "echo 'Snippets directory ready'"
    ]
    on_failure = fail
  }

  # Transfer cloud-init file
  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[each.key].filename
    destination = "/var/lib/vz/snippets/${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}.yml"
  }

  depends_on = [local_file.cloud_init_user_data_file]
}

# =============================================================================
# PROXMOX RESOURCES
# =============================================================================

resource "proxmox_pool" "server_pool" {
  poolid = "${var.tenant_cluster_name}-${var.pool_name}-pool"
}

resource "proxmox_vm_qemu" "node" {
  for_each = local.nodes

  # Basic Configuration
  name        = "${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}"
  target_node = var.proxmox_node
  pool        = proxmox_pool.server_pool.poolid
  clone       = var.vms_template
  agent       = var.vms_agent
  vm_state    = var.vms_state
  onboot      = false

  # CPU Configuration
  sockets = var.vms_sockets
  cores   = var.vms_cores
  vcpus   = var.vms_vcpus

  # Memory Configuration
  memory = var.vms_memory

  # Boot Configuration
  boot   = var.vms_boot
  scsihw = var.vms_scsihw

  # Network Configuration
  network {
    id     = 0
    bridge = var.network_bridge
    model  = var.network_model
  }

  # Disk Configuration
  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.storage_disk
          size    = var.vms_disk_size
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.storage_disk
        }
      }
    }
  }

  # Cloud-Init Configuration
  ciupgrade    = false
  cicustom     = "user=local:snippets/${var.tenant_cluster_name}-${var.pool_name}-node-${format("%02s", each.key)}.yml"
  searchdomain = var.search_domain
  nameserver   = var.nameserver
  ipconfig0    = "ip=${cidrhost(var.network_cidr, tonumber(each.key) + var.network_offset)}/${split("/", var.network_cidr)[1]},gw=${var.network_gateway}"
  skip_ipv6    = true

  depends_on = [
    proxmox_pool.server_pool,
    null_resource.cloud_init_config
  ]
}
