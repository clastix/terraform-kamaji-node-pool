# Proxmox Provider

Creates Proxmox VE virtual machines for Kamaji node pools with automatic bootstrap token generation.

## Usage

1. **Configure variables**:
   ```bash
   cp main.auto.tfvars.sample main.auto.tfvars
   # Edit main.auto.tfvars with your settings
   ```

2. **Set Proxmox credentials**:
   ```bash
   export TF_VAR_proxmox_password="your-password"
   ```

3. **Deploy**:
   ```bash
   terraform init
   terraform apply
   ```

## Configuration Example

```hcl
# main.auto.tfvars
tenant_cluster_name    = "my-cluster"
tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"

proxmox_host     = "my-proxmox-host.example.com"
proxmox_node     = "pve-node1"
proxmox_api_url  = "https://my-proxmox-host:8006/api2/json"
proxmox_user     = "terraform@pve"

node_pools = [
  {
    name           = "workers"
    size           = 3
    vms_template   = "ubuntu-24.04-template"
    vms_memory     = 2048
    vms_cores      = 2
    vms_disk_size  = 20
    network_cidr   = "10.10.10.0/24"
    network_gateway = "10.10.10.1"
    network_bridge = "vmbr0"
  }
]
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tenant_cluster_name` | `string` | Required | Tenant cluster name |
| `tenant_kubeconfig_path` | `string` | `"~/.kube/config"` | Kubeconfig path |
| `yaki_url` | `string` | `"https://goyaki.clastix.io"` | YAKI bootstrap URL |
| `node_pools` | `list(object)` | Required | Node pool configurations |
| `proxmox_host` | `string` | Required | Proxmox hostname/IP |
| `proxmox_node` | `string` | Required | Proxmox node name |
| `proxmox_api_url` | `string` | Required | Proxmox API URL |
| `proxmox_user` | `string` | Required | Proxmox user |
| `proxmox_password` | `string` | Required | Proxmox password |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_private_key_path` | `string` | `"~/.ssh/id_rsa"` | SSH private key path |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |

## Outputs

- `node_pool_creation_summary` - Deployment summary
- `vm_details` - VM information
- `bootstrap_token` - Bootstrap token info (sensitive)
- `cluster_info` - Cluster configuration
- `useful_commands` - Ready-to-use commands

## Requirements

- Terraform >= 1.0
- Proxmox provider (Telmate/proxmox) >= 3.0.1-rc6
- SSH access to Proxmox host
- VM template with cloud-init support

