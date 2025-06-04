# Proxmox Example

Example configuration for deploying Kamaji node pools on Proxmox VE using virtual machines.

## Usage

1. **Copy and customize**:
   ```bash
   cp example.tf main.tf
   # Edit main.tf with your configuration
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

## Configuration

Update the following in `main.tf`:
- `tenant_cluster_name` - Your Kamaji tenant cluster name
- `kubeconfig_path` - Path to your tenant cluster kubeconfig
- `proxmox_host`, `proxmox_node`, `proxmox_api_url` - Your Proxmox configuration
- `proxmox_user` - Your Proxmox username
- VM template and network configuration
- Node pool specifications (memory, cores, disk size, etc.)

## Requirements

- Terraform >= 1.0
- Proxmox provider (Telmate/proxmox) >= 3.0.1-rc6
- SSH access to Proxmox host
- VM template with cloud-init support 