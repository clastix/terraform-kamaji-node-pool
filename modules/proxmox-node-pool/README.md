# Proxmox Node Pool Module

Creates virtual machines on Proxmox VE for Kubernetes worker nodes in Kamaji tenant clusters.

## Usage

```hcl
module "proxmox_node_pool" {
  source = "../../modules/proxmox-node-pool"

  # Cluster configuration
  tenant_cluster_name = "my-cluster"
  pool_name          = "workers"
  pool_size          = 3

  # Network configuration
  network_cidr    = "10.10.10.0/24"
  network_gateway = "10.10.10.1"
  network_bridge  = "vmbr0"
  search_domain   = "example.com"

  # VM configuration
  vms_template  = "ubuntu-24.04-template"
  vms_memory    = 2048
  vms_cores     = 2
  vms_disk_size = 20

  # Proxmox configuration
  proxmox_host     = "proxmox.example.com"
  proxmox_node     = "pve"
  proxmox_api_url  = "https://proxmox.example.com:8006/api2/json"
  proxmox_user     = "terraform@pve"
  proxmox_password = var.proxmox_password

  # SSH configuration
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"

  # Bootstrap command
  runcmd = "kubeadm join cluster-api:6443 --token abc123.xyz789"
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tenant_cluster_name` | `string` | Required | Tenant cluster name |
| `pool_name` | `string` | `"default"` | Node pool name |
| `pool_size` | `number` | `3` | Number of VMs |
| `network_cidr` | `string` | `"10.10.10.0/24"` | Network CIDR |
| `network_gateway` | `string` | `"10.10.10.1"` | Network gateway |
| `network_offset` | `number` | `10` | IP address offset |
| `network_bridge` | `string` | Required | Proxmox network bridge |
| `network_model` | `string` | `"virtio"` | Network interface model |
| `nameserver` | `string` | `"8.8.8.8"` | DNS resolver |
| `search_domain` | `string` | Required | DNS search domain |
| `vms_template` | `string` | Required | VM template name |
| `vms_state` | `string` | `"started"` | VM state |
| `vms_agent` | `number` | `1` | QEMU Guest Agent |
| `vms_sockets` | `number` | `1` | CPU sockets |
| `vms_cores` | `number` | `2` | CPU cores per socket |
| `vms_vcpus` | `number` | `0` | vCPUs (0 = auto) |
| `vms_memory` | `number` | `1024` | Memory (MB) |
| `vms_boot` | `string` | `"order=scsi0"` | Boot order |
| `vms_scsihw` | `string` | `"virtio-scsi-single"` | SCSI controller |
| `storage_disk` | `string` | `"local"` | Storage location |
| `vms_disk_size` | `number` | `16` | Disk size (GB) |
| `proxmox_host` | `string` | Required | Proxmox hostname/IP |
| `proxmox_node` | `string` | Required | Proxmox node name |
| `proxmox_api_url` | `string` | Required | Proxmox API URL |
| `proxmox_user` | `string` | Required | Proxmox user |
| `proxmox_password` | `string` | Required | Proxmox password |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_private_key_path` | `string` | `"~/.ssh/id_rsa"` | SSH private key path |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |
| `runcmd` | `string` | `"echo 'Hello, World!'"` | Bootstrap command |

## Outputs

- `vm_details` - VM information (name, IP, memory, CPU, state)

## Requirements

- Terraform >= 1.0
- Proxmox provider (Telmate/proxmox) >= 3.0.1-rc6
- SSH access to Proxmox host
- VM template with cloud-init support 