# vSphere Provider

Creates VMware vSphere virtual machines for Kamaji node pools with automatic bootstrap token generation.

## Usage

1. **Configure variables**:
   ```bash
   cp main.auto.tfvars.sample main.auto.tfvars
   # Edit main.auto.tfvars with your settings
   ```

2. **Set vSphere credentials**:
   ```bash
   export TF_VAR_vsphere_username="your-username"
   export TF_VAR_vsphere_password="your-password"
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

vsphere_server     = "vcenter.example.com"
vsphere_datacenter = "Datacenter"
vsphere_cluster    = "Cluster"
vsphere_datastore  = "datastore1"
vsphere_network    = "VM Network"

node_pools = [
  {
    name           = "workers"
    size           = 3
    vm_template    = "ubuntu-24.04-template"
    vm_memory      = 4096
    vm_cpu         = 2
    vm_disk_size   = 20
    network_cidr   = "192.168.1.0/24"
    network_gateway = "192.168.1.1"
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
| `vsphere_server` | `string` | Required | vCenter server |
| `vsphere_username` | `string` | Required | vSphere username |
| `vsphere_password` | `string` | Required | vSphere password |
| `vsphere_datacenter` | `string` | Required | vSphere datacenter |
| `vsphere_cluster` | `string` | Required | vSphere cluster |
| `vsphere_datastore` | `string` | Required | vSphere datastore |
| `vsphere_network` | `string` | Required | vSphere network |
| `vsphere_folder` | `string` | `""` | VM folder |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |

## Outputs

- `node_pool_creation_summary` - Deployment summary
- `vm_details` - VM information
- `bootstrap_token` - Bootstrap token info (sensitive)
- `cluster_info` - Cluster configuration
- `useful_commands` - Ready-to-use commands

## Requirements

- Terraform >= 1.0
- VMware vSphere provider >= 2.0
- vCenter/ESXi access with appropriate permissions
- VM template with cloud-init support

