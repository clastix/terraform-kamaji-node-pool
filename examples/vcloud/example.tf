# Example: VMware Cloud Director Provider Usage
# This example shows how to use the vCloud provider wrapper

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.0"
    }
  }
}

# Configure the VMware Cloud Director provider
provider "vcd" {
  user                 = var.vcd_username
  password             = var.vcd_password
  url                  = var.vcd_url
  org                  = var.vcd_org_name
  vdc                  = var.vcd_vdc_name
  allow_unverified_ssl = var.vcd_allow_insecure
  logging              = var.vcd_logging
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

# Use the vCloud provider module
module "vcloud_kamaji_node_pools" {
  source = "../../providers/vcloud"

  # Cluster configuration
  tenant_cluster_name    = "my-vcloud-cluster"
  tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
  yaki_url              = "https://goyaki.clastix.io"

  # Node pools configuration
  node_pools = [
    {
      name                      = "workers"
      size                      = 3
      node_cpus                 = 2
      node_cpu_cores            = 2
      node_memory               = 4096
      node_disk_size            = 50
      node_disk_storage_profile = "Standard"
      network_name              = "MyNetwork"
      network_adapter_type      = "VMXNET3"
      ip_allocation_mode        = "DHCP"
      template_name             = "ubuntu-24.04-template"
    }
  ]

  # VMware Cloud Director configuration
  vcd_url                = var.vcd_url
  vcd_username           = var.vcd_username
  vcd_password           = var.vcd_password
  vcd_org_name           = "MyOrganization"
  vcd_vdc_name           = "MyVDC"
  vcd_catalog_org_name   = "MyOrganization"
  vcd_catalog_name       = "Templates"
  vcd_allow_insecure     = false
  vcd_logging            = false

  # SSH configuration
  ssh_user             = "ubuntu"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
  ssh_private_key_path = "~/.ssh/id_rsa"
}

# Variables
variable "vcd_username" {
  description = "VMware Cloud Director username"
  type        = string
  sensitive   = true
}

variable "vcd_password" {
  description = "VMware Cloud Director password"
  type        = string
  sensitive   = true
}

variable "vcd_url" {
  description = "VMware Cloud Director URL"
  type        = string
}

variable "vcd_org_name" {
  description = "VMware Cloud Director organization name"
  type        = string
  default     = "MyOrganization"
}

variable "vcd_vdc_name" {
  description = "VMware Cloud Director VDC name"
  type        = string
  default     = "MyVDC"
}

variable "vcd_allow_insecure" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = false
}

variable "vcd_logging" {
  description = "Enable debug logging"
  type        = bool
  default     = false
}

variable "tenant_kubeconfig_path" {
  description = "Path to tenant cluster kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

# Outputs
output "deployment_summary" {
  description = "Deployment summary"
  value       = module.vcloud_kamaji_node_pools.node_pool_creation_summary
}

output "vapp_details" {
  description = "vApp details"
  value       = module.vcloud_kamaji_node_pools.vapp_details
} 