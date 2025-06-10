# Azure Node Pool Module

Creates Azure Virtual Machine Scale Sets for Kamaji tenant cluster worker nodes with automatic scaling capabilities.

## Features

- **Virtual Machine Scale Sets** with automatic scaling
- **Network Security Groups** with Kubernetes-optimized rules
- **Ubuntu 24.04 LTS** support
- **Automatic instance repair** for failed VMs
- **CPU-based autoscaling** with configurable thresholds
- **Bootstrap token integration** via cloud-init

## Usage

```hcl
module "azure_node_pool" {
  source = "../../modules/azure-node-pool"

  # Cluster configuration
  tenant_cluster_name = "charlie"
  pool_name          = "default"

  # Pool sizing
  pool_size     = 3
  pool_min_size = 1
  pool_max_size = 9

  # Azure configuration
  azure_location            = "italynorth"
  azure_resource_group_name = "kamaji"
  azure_vnet_name          = "kamaji-vnet"
  azure_subnet_name        = "kamaji-subnet"

  # VM configuration
  vm_size            = "Standard_D2s_v3"
  assign_public_ip   = true
  node_disk_size     = 30
  node_disk_type     = "Premium_LRS"

  # Autoscaling
  enable_autoscaling        = true
  scale_out_cpu_threshold   = 75
  scale_in_cpu_threshold    = 25

  # Bootstrap command
  runcmd = module.bootstrap_token.join_cmd

  tags = {
    Environment = "production"
    Project     = "kamaji"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |
| cloudinit | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |
| cloudinit | >= 2.0 |

## Resources

- `azurerm_linux_virtual_machine_scale_set` - Main VMSS resource
- `azurerm_network_security_group` - Security group for nodes
- `azurerm_network_security_rule` - Security rules
- `azurerm_monitor_autoscale_setting` - Autoscaling configuration

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `tenant_cluster_name` | Name of the tenant cluster | `string` | `"charlie"` |
| `pool_name` | Name of the node pool | `string` | `"default"` |
| `pool_size` | The size of the node pool | `number` | `3` |
| `pool_min_size` | The minimum size of the node pool | `number` | `1` |
| `pool_max_size` | The maximum size of the node pool | `number` | `9` |
| `azure_location` | Azure region where resources are created | `string` | `"italynorth"` |
| `azure_resource_group_name` | Name of the Azure resource group | `string` | `"kamaji"` |
| `azure_vnet_name` | Name of the Azure virtual network | `string` | `"kamaji-vnet"` |
| `azure_subnet_name` | Name of the Azure subnet | `string` | `"kamaji-subnet"` |
| `vm_size` | Size of the virtual machines | `string` | `"Standard_D2s_v3"` |
| `assign_public_ip` | Whether to assign public IP addresses to VMs | `bool` | `true` |
| `node_disk_size` | Disk size for each node in GB | `number` | `30` |
| `node_disk_type` | Storage account type for each node | `string` | `"Premium_LRS"` |
| `ssh_user` | SSH user for the nodes | `string` | `"ubuntu"` |
| `ssh_public_key_path` | Path to the SSH public key | `string` | `"~/.ssh/id_rsa.pub"` |
| `enable_autoscaling` | Enable automatic scaling based on CPU metrics | `bool` | `true` |
| `scale_out_cpu_threshold` | CPU threshold percentage to trigger scale out | `number` | `75` |
| `scale_in_cpu_threshold` | CPU threshold percentage to trigger scale in | `number` | `25` |
| `runcmd` | Command to run on the node at first boot time | `string` | `"echo 'Hello, World!'"` |

## Outputs

| Name | Description |
|------|-------------|
| `vmss_details` | Virtual Machine Scale Set details |
| `autoscale_settings` | Autoscale settings details |
| `network_security_group` | Network Security Group details |

## Security Groups

The module creates a Network Security Group with the following rules:

- **Outbound**: Allow all outbound traffic
- **SSH**: Allow inbound SSH (port 22) from anywhere
- **Cluster Internal**: Allow all traffic within the subnet

## Scaling Behavior

This module supports both manual and automatic scaling modes:

### Manual Scaling (`enable_autoscaling = false`)
- **Direct Control**: Terraform directly manages VMSS instance count
- **pool_size Changes**: Changing `pool_size` will update the VMSS immediately on `terraform apply`
- **No Lifecycle Rules**: No `ignore_changes` applied to instances
- **Use Case**: Predictable workloads requiring manual capacity control

### Automatic Scaling (`enable_autoscaling = true`)
- **CPU-Based**: Azure autoscaler manages instance count based on CPU metrics
- **Scale Out**: When average CPU > 75% for 5 minutes
- **Scale In**: When average CPU < 25% for 5 minutes
- **Cooldown**: 1 minute between scaling actions
- **Default Capacity**: `pool_size` sets the initial/default capacity
- **Lifecycle Protection**: Terraform ignores instance count changes made by autoscaler

## Instance Repair

Automatic instance repair is enabled by default with a 30-minute grace period for failed VMs. 