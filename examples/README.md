# Examples

Usage examples for Terraform Kamaji node pool modules.

## Available Examples

| Provider | Description |
|----------|-------------|
| `aws/example.tf` | EC2 Auto Scaling Groups |
| `proxmox/example.tf` | Proxmox VE virtual machines |
| `vsphere/example.tf` | VMware vSphere VMs |
| `vcloud/example.tf` | VMware Cloud Director vApps |

## Usage

1. **Copy example**:
   ```bash
   cd examples/aws  # or proxmox, vsphere, vcloud
   cp example.tf main.tf
   ```

2. **Customize configuration**:
   - Update cluster names and paths
   - Configure provider credentials
   - Adjust node pool specifications

3. **Set authentication**:
   ```bash
   # AWS
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"
   
   # Proxmox
   export TF_VAR_proxmox_password="your-password"
   
   # vSphere
   export TF_VAR_vsphere_password="your-password"
   
   # vCloud
   export TF_VAR_vcd_password="your-password"
   ```

4. **Deploy**:
   ```bash
   terraform init
   terraform apply
   ```

## Requirements

- Terraform >= 1.0
- Provider-specific credentials and infrastructure
- Existing Kamaji tenant cluster with kubeconfig

## Common Configuration

All examples require:
- `tenant_cluster_name` - Name of your Kamaji tenant cluster
- `kubeconfig_path` - Path to tenant cluster kubeconfig
- Provider-specific authentication variables

## Troubleshooting

- **Authentication**: Verify credentials and permissions
- **Templates**: Ensure VM/AMI templates exist and are accessible
- **Network**: Check connectivity and network configuration
- **Resources**: Verify sufficient resources in target environment 