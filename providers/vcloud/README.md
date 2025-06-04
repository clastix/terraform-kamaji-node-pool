# vCloud Provider

Creates VMware Cloud Director vApps and VMs for Kamaji node pools with automatic bootstrap token generation.

## Usage

1. **Configure variables**:
   ```bash
   cp main.auto.tfvars.sample main.auto.tfvars
   # Edit main.auto.tfvars with your settings
   ```

2. **Set vCloud credentials**:
   ```bash
   export TF_VAR_vcd_username="your-username"
   export TF_VAR_vcd_password="your-password"
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

vcd_url = "https://vcd.example.com/api"
vcd_org = "my-org"
vcd_vdc = "my-vdc"

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
    vcd_catalog    = "my-catalog"
    vcd_network    = "my-network"
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
| `vcd_url` | `string` | Required | vCloud Director URL |
| `vcd_username` | `string` | Required | vCloud username |
| `vcd_password` | `string` | Required | vCloud password |
| `vcd_org` | `string` | Required | vCloud organization |
| `vcd_vdc` | `string` | Required | Virtual datacenter |
| `ssh_user` | `string` | `"ubuntu"` | SSH user |
| `ssh_public_key_path` | `string` | `"~/.ssh/id_rsa.pub"` | SSH public key path |

## Outputs

- `node_pool_creation_summary` - Deployment summary
- `vm_details` - VM information
- `vapp_details` - vApp information
- `bootstrap_token` - Bootstrap token info (sensitive)
- `cluster_info` - Cluster configuration
- `useful_commands` - Ready-to-use commands

## Requirements

- Terraform >= 1.0
- VMware Cloud Director provider >= 3.0
- vCloud Director access with appropriate permissions
- VM template with cloud-init support

