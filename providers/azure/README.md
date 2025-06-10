# Azure Provider for Kamaji Node Pools

Ready-to-use Terraform implementation for creating multiple Kubernetes worker node pools on Microsoft Azure using Virtual Machine Scale Sets (VMSS).

## Features

- **Multiple Node Pools** with different configurations per pool
- **Virtual Machine Scale Sets** with automatic scaling per pool
- **CPU-based autoscaling** with configurable thresholds per pool
- **Automatic instance repair** for failed VMs (configurable per pool)
- **Network Security Groups** with Kubernetes-optimized rules
- **Ubuntu 24.04 LTS** support
- **Bootstrap token integration** with automatic cluster joining via YAKI

## Prerequisites

### Required Infrastructure

Before using this provider, you must have:

1. **Azure Resource Group** - Where all resources will be created
2. **Virtual Network (VNet)** - Network for the node pools
3. **Subnet** - Subnet within the VNet for VM instances
4. **Kamaji tenant cluster** - Running cluster with accessible kubeconfig

### Required Tools

- Terraform >= 1.0
- Azure CLI >= 2.0 (authenticated)
- SSH key pair for node access
- [direnv](https://direnv.net/) (optional, for automatic environment management)

## Quick Start

### 1. Authentication

```bash
# Login to Azure
az login

# Set subscription (if needed)
az account set --subscription "your-subscription-id"

# Verify access
az account show
```

### 2. Environment Configuration

**Option A: Using .envrc (Recommended)**

```bash
# Install direnv (if not already installed)
# macOS: brew install direnv
# Ubuntu: apt install direnv

# Add direnv hook to your shell
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # for bash
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc    # for zsh

# Copy and edit .envrc file
cp .envrc.sample .envrc
vim .envrc

# Allow direnv to load the environment
direnv allow
```

**Option B: Using tfvars file**

```bash
# Copy sample configuration
cp main.auto.tfvars.sample main.auto.tfvars

# Edit configuration - MAKE SURE TO SET azure_subscription_id
vim main.auto.tfvars
```

### 3. Deploy

```bash
# Initialize Terraform
terraform init

# Review plan
terraform plan

# Apply configuration
terraform apply
```

## Configuration

### Required Variables

```hcl
# Azure subscription (REQUIRED - no default)
azure_subscription_id = "your-subscription-id"

# Cluster identity
tenant_cluster_name = "your-cluster-name"

# Bootstrap configuration
tenant_kubeconfig_path = "/path/to/your/cluster.kubeconfig"

# Azure infrastructure (must exist)
azure_resource_group_name = "your-resource-group"
azure_vnet_name          = "your-vnet"
azure_subnet_name        = "your-subnet"

# Node pools configuration
node_pools = [
  {
    name           = "default"
    size           = 3
    node_disk_size = 30
    vm_size        = "Standard_D2s_v3"
    # ... other pool-specific settings
  }
]
```

### Node Pool Configuration

Each node pool supports the following configuration options:

```hcl
node_pools = [
  {
    # Required fields
    name           = "pool-name"        # Unique name for this pool
    size           = 3                  # Number of nodes in the pool
    node_disk_size = 30                 # Disk size in GB
    vm_size        = "Standard_D2s_v3"  # Azure VM size

    # Optional fields with defaults
    min_size               = 1          # Minimum nodes for autoscaling
    max_size               = 9          # Maximum nodes for autoscaling
    node_disk_type         = "Premium_LRS"  # Storage type
    assign_public_ip       = true       # Assign public IPs
    enable_autoscaling     = false      # Enable CPU-based autoscaling
    scale_out_cpu_threshold = 75        # CPU threshold to scale out
    scale_in_cpu_threshold  = 25        # CPU threshold to scale in
    enable_automatic_instance_repair = false  # Enable automatic repair
    automatic_instance_repair_grace_period = "PT30M"  # Repair grace period
    upgrade_mode           = "Manual"   # Scale set upgrade mode
  }
]
```

### Multiple Node Pools Example

```hcl
node_pools = [
  {
    name           = "default"
    size           = 3
    node_disk_size = 50
    vm_size        = "Standard_D2s_v3"
    assign_public_ip = true
    enable_autoscaling = false
  },
  {
    name           = "system"
    size           = 2
    node_disk_size = 100
    vm_size        = "Standard_D4s_v3"
    assign_public_ip = false
    enable_autoscaling = true
    scale_out_cpu_threshold = 80
    scale_in_cpu_threshold  = 30
    enable_automatic_instance_repair = true
  }
]
```

### Environment Variable Options

You can override any Terraform variable using environment variables:

```bash
# Using .envrc file
export TF_VAR_azure_subscription_id="your-subscription-id"
export TF_VAR_azure_location="italynorth"
export TF_VAR_tenant_cluster_name="customer-azure"
export TF_VAR_tenant_kubeconfig_path="/path/to/kubeconfig"

# Or set Azure provider environment variables
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-service-principal-id"        # if using service principal
export ARM_CLIENT_SECRET="your-service-principal-secret" # if using service principal
export ARM_TENANT_ID="your-tenant-id"                   # if using service principal
```

### Infrastructure Setup

If you haven't created the required Azure infrastructure:

```bash
# Create resource group
az group create --name "kamaji" --location "italynorth"

# Create virtual network with subnet
az network vnet create \
  --resource-group "kamaji" \
  --name "kamaji-vnet" \
  --address-prefix "10.10.0.0/16" \
  --subnet-name "kamaji-subnet" \
  --subnet-prefix "10.10.10.0/24" \
  --location "italynorth"
```

## Scaling Configuration

Each node pool supports both manual and automatic scaling modes:

### Manual Scaling (enable_autoscaling = false)
- **Terraform Control**: Direct control over instance count via `size`
- **No Autoscaler**: Azure autoscaler is disabled for this pool
- **Use Case**: When you want predictable, manual control over node count
- **Scaling**: Change `size` in tfvars and run `terraform apply`

### Automatic Scaling (enable_autoscaling = true)
- **CPU-Based**: Automatic scaling based on CPU utilization
- **Scale Out**: When average CPU > threshold for 5 minutes
- **Scale In**: When average CPU < threshold for 5 minutes  
- **Cooldown**: 1 minute between scaling actions
- **Range**: min_size to max_size instances
- **Note**: `size` sets the default capacity; actual scaling is managed by Azure

## Security

### Network Security Groups

Automatically creates security group rules for:

- **Outbound**: Allow all outbound traffic
- **SSH**: Allow inbound SSH (port 22) from anywhere
- **Cluster Internal**: Allow all traffic within the subnet

### VM Security

- SSH key-based authentication (password disabled)
- Premium SSD storage by default
- Automatic security updates via cloud-init

## Monitoring

### Instance Health

- Automatic instance repair configurable per pool
- Failed instances can be manually replaced or automatically via Azure policies

### Scaling Metrics

- CPU percentage monitoring every minute
- 5-minute evaluation windows for scaling decisions
- Configurable thresholds per pool for scale-out/scale-in

## Troubleshooting

### Common Issues

1. **Subscription ID Error**
   ```bash
   # Make sure subscription ID is set
   export TF_VAR_azure_subscription_id="your-subscription-id"
   # Or update main.auto.tfvars
   ```

2. **Authentication Errors**
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

3. **Resource Group Not Found**
   ```bash
   az group create --name "kamaji" --location "italynorth"
   ```

4. **VNet/Subnet Not Found**
   ```bash
   az network vnet create --resource-group "kamaji" --name "kamaji-vnet" --address-prefix "10.10.0.0/16"
   ```

5. **Kubeconfig Issues**
   - Verify kubeconfig path exists
   - Test cluster connectivity: `kubectl --kubeconfig=/path/to/config get nodes`

### Debugging

```bash
# Enable detailed logging
export TF_LOG=DEBUG

# Check Azure resources
az resource list --resource-group "kamaji" --output table

# Verify VM scale sets (one per pool)
az vmss list --resource-group "kamaji" --output table
```

## Outputs

After successful deployment:

```bash
# View outputs
terraform output

# Get cluster information
terraform output cluster_info

# Get all node pools details  
terraform output node_pools
```

Example output structure:
```bash
cluster_info = {
  "azure_location" = "italynorth"
  "node_pools_count" = 2
  "node_pools_names" = ["default", "system"]
  "tenant_cluster_name" = "customer-azure"
}

node_pools = {
  "default" = {
    "autoscale_settings" = { ... }
    "network_security_group" = { ... }
    "vmss_details" = { ... }
  }
  "system" = {
    "autoscale_settings" = { ... }
    "network_security_group" = { ... }
    "vmss_details" = { ... }
  }
}
```

## Cleanup

```bash
# Destroy infrastructure
terraform destroy

# Confirm removal
az resource list --resource-group "kamaji" --output table
```

## Support

- **Documentation**: [Kamaji Documentation](https://kamaji.clastix.io)
- **Bootstrap Script**: [YAKI](https://goyaki.clastix.io)
- **Issues**: Report issues in the project repository 