# vCloud Example

Example configuration for deploying Kamaji node pools on VMware Cloud Director using vApps and VMs.

## Usage

1. **Copy and customize**:
   ```bash
   cp example.tf main.tf
   # Edit main.tf with your configuration
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

## Configuration

Update the following in `main.tf`:
- `tenant_cluster_name` - Your Kamaji tenant cluster name
- `kubeconfig_path` - Path to your tenant cluster kubeconfig
- `vcd_url`, `vcd_org`, `vcd_vdc` - Your vCloud Director configuration
- `vcd_catalog`, `vcd_network` - Catalog and network settings
- VM template and network configuration
- Node pool specifications (memory, CPU, disk size, etc.)

## Requirements

- Terraform >= 1.0
- VMware Cloud Director provider >= 3.0
- vCloud Director access with appropriate permissions
- VM template with cloud-init support 