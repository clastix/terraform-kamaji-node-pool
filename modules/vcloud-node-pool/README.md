# vCloud Node Pool Module

Creates vApps and VMs on VMware Cloud Director for Kubernetes worker nodes in Kamaji tenant clusters.

## Usage

```hcl
module "vcloud_node_pool" {
  source = "../../modules/vcloud-node-pool"

  # Cluster configuration
  tenant_cluster_name = "my-cluster"
  pool_name          = "workers"
  pool_size          = 3

  # VM configuration
  vm_template    = "ubuntu-24.04-template"
  vm_memory      = 4096
  vm_cpu         = 2
  vm_disk_size   = 20

  # vCloud configuration
  vcd_org        = "my-org"
  vcd_vdc        = "my-vdc"
  vcd_catalog    = "my-catalog"
  vcd_network    = "my-network"

  # Network configuration
  network_cidr    = "192.168.1.0/24"
  network_gateway = "192.168.1.1"
  network_offset  = 100

  # SSH configuration
  ssh_public_key_path = "~/.ssh/id_rsa.pub"

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
| `vm_template` | `string` | Required | VM template name |
| `vm_memory` | `number` | `2048` | Memory (MB) |
| `vm_cpu` | `number` | `2` | CPU cores |
| `vm_disk_size` | `number` | `20` | Disk size (GB) |
| `vcd_org` | `string` | Required | vCloud organization |
| `vcd_vdc` | `string` | Required | Virtual datacenter |
| `vcd_catalog` | `string` | Required | vCloud catalog |
| `vcd_network` | `string` | Required | vCloud network |
| `network_cidr` | `string` | `"192.168.1.0/24"` | Network CIDR |
| `network_gateway` | `string` | `"192.168.1.1"` | Network gateway |
| `network_offset` | `number` | `10` | IP address offset |
| `nameserver` | `string` | `"8.8.8.8"` | DNS resolver |
| `search_domain` | `string` | `""` | DNS search domain |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |
| `runcmd` | `string` | `"echo 'Hello, World!'"` | Bootstrap command |

## Outputs

- `vm_details` - VM information (name, IP, memory, CPU, state)
- `vapp_details` - vApp information

## Requirements

- Terraform >= 1.0
- VMware Cloud Director provider >= 3.0
- vCloud Director access with appropriate permissions
- VM template with cloud-init support
