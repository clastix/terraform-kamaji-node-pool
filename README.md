# Terraform Kamaji Node Pools

A comprehensive Terraform module collection for creating Kubernetes worker node pools across multiple cloud providers for [Kamaji](https://kamaji.clastix.io), the Control Plane Manager for Kubernetes.

The machines created by this project automatically will create a secure bootstrap tokens and join the Kamaji tenant clusters using the [`yaki`](https://goyaki.clastix.io/) bootstrap script.

## Supported Providers

| Provider | Technology | Description | Scaling | Status |
|----------|------------|-------------|---------|---------|
| **AWS** | Auto Scaling Groups | EC2 instances with automatic scaling and availability zones | Automatic | Available |
| **Azure** | Virtual Machine Scale Sets | Azure VMs with automatic scaling and availability zones | Automatic | Available |
| **Proxmox** | Virtual Machines | Virtual Machines on Proxmox VE | Manual | Available |
| **vCloud** | vApps | Multi-tenant Virtual Machines on VMware Cloud Director with vApp isolation | Manual | Available |
| **vSphere** | Virtual Machines | Virtual Machines on VMware vSphere/vCenter | Manual | Available |

## Bootstrap Token Management

This project has a [bootstrap-token module](modules/bootstrap-token/README.md) that automatically connect to the tenant cluster in Kamaji using the proper `tenant.kubeconfig` file, generate the bootstrap token, constructs the join commands and joining using the `yaki` bootstrap script.

## Naming Convention
Assuming you have a user called `foo`, and a tenant cluster `tcp-charlie`, you can create several node pools: `application`, `default`, `system` as shown in the following structure:

```sh
foo
├── tcp-alpha
├── tcp-beta
└── tcp-charlie
    ├── application-pool
    │   ├── tcp-charlie-application-node-00
    │   └── tcp-charlie-application-node-01
    ├── default-pool
    │   ├── tcp-charlie-default-node-00
    │   ├── tcp-charlie-default-node-01
    │   └── tcp-charlie-default-node-02
    └── system-pool
        ├── tcp-charlie-system-node-00
        └── tcp-charlie-system-node-01
```

## Project Structure

```terraform-kamaji-node-pool/
├── modules/
│   ├── bootstrap-token/         # Shared bootstrap token generation
│   ├── aws-node-pool/           # AWS Auto Scaling Groups
│   ├── azure-node-pool/         # Azure Virtual Machine Scale Sets
│   ├── proxmox-node-pool/       # Proxmox VE virtual machines
│   ├── vsphere-node-pool/       # VMware vSphere VMs
│   ├── vcloud-node-pool/        # VMware Cloud Director vApps
│   ├── templates/               # Shared cloud-init templates
│   └── common/                  # Common variable definitions
├── providers/
│   ├── aws/                     # AWS provider implementation
│   ├── azure/                   # Azure provider implementation
│   ├── proxmox/                 # Proxmox provider implementation
│   ├── vsphere/                 # vSphere provider implementation
│   └── vcloud/                  # vCloud provider implementation
└── examples/
    ├── aws/                     # AWS usage examples
    ├── azure/                   # Azure usage examples
    ├── proxmox/                 # Proxmox usage examples
    ├── vsphere/                 # vSphere usage examples
    └── vcloud/                  # vCloud usage examples
```

## Quick Start

1. **Choose your provider**:
   ```bash
   # Navigate to your preferred provider
   cd providers/aws      # for AWS Auto Scaling Groups
   cd providers/azure    # for Azure Virtual Machine Scale Sets
   cd providers/proxmox  # for Proxmox VE virtual machines
   cd providers/vsphere  # for VMware vSphere VMs
   cd providers/vcloud   # for VMware Cloud Director vApps
   ```

2. **Choose your deployment approach**:
   - Use `providers/` for complete, ready-to-use implementations
   - Use `modules/` for custom integrations
   - Use `examples/` for reference configurations

3. **Configure your environment**:
   ```bash
   # Copy sample configuration
   cp main.auto.tfvars.sample main.auto.tfvars
   
   # Edit and fill the configuration
   vim main.auto.tfvars
   ```

4. **Set up authentication**:
   ```bash
   # AWS
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   
   # Azure
   export ARM_CLIENT_ID="your-client-id"
   export ARM_CLIENT_SECRET="your-client-secret"
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   
   # Proxmox
   export TF_VAR_proxmox_user="terraform@pve" ## user
   export TF_VAR_proxmox_password="your-password"
   
   # vSphere
   export TF_VAR_vsphere_username="your-username"
   export TF_VAR_vsphere_password="your-password"
   
   # vCloud
   export TF_VAR_vcd_username="your-username"
   export TF_VAR_vcd_password="your-password"
   ```

5. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

6. **Check**:
   ```bash
   kubectl --kubeconfig tenant.kubeconfig get nodes -o wide
   ```

## License

This project is released under Apache2 license.

## Contributing

This project follows infrastructure-as-code best practices and welcomes contributions.

Please ensure:
- Consistent module structure across providers
- Comprehensive variable documentation
- Proper output definitions
- Security-conscious defaults

