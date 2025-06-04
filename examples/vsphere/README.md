# vSphere Example

Example configuration for deploying Kamaji node pools on VMware vSphere using virtual machines.

## Usage

1. **Copy and customize**:
   ```bash
   cp example.tf main.tf
   # Edit main.tf with your configuration
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

## Configuration

Update the following in `main.tf`:
- `tenant_cluster_name` - Your Kamaji tenant cluster name
- `kubeconfig_path` - Path to your tenant cluster kubeconfig
- `vsphere_server`, `vsphere_datacenter`, `vsphere_cluster` - Your vSphere configuration
- `vsphere_datastore`, `vsphere_network` - Storage and network settings
- VM template and network configuration
- Node pool specifications (memory, CPU, disk size, etc.)

## Requirements

- Terraform >= 1.0
- VMware vSphere provider >= 2.0
- vCenter/ESXi access with appropriate permissions
- VM template with cloud-init support 