# Example: vSphere Provider Usage
# This example shows how to use the vSphere provider wrapper

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.13.0"
    }
  }
}

# Configure the vSphere provider
provider "vsphere" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

# Use the vSphere provider module
module "vsphere_kamaji_node_pools" {
  source = "../../providers/vsphere"

  # Cluster configuration
  tenant_cluster_name    = "my-vsphere-cluster"
  tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
  yaki_url              = "https://goyaki.clastix.io"

  # Node pools configuration
  node_pools = [
    {
      name            = "workers"
      size            = 3
      node_memory     = 4096
      node_cores      = 2
      node_disk_size  = 50
      node_guest      = "ubuntu64Guest"
      network_cidr    = "192.168.100.0/24"
      network_gateway = "192.168.100.1"
      network_offset  = 10
    }
  ]

  # vSphere configuration
  vsphere_server                 = var.vsphere_server
  vsphere_username               = var.vsphere_username
  vsphere_password               = var.vsphere_password
  vsphere_datacenter             = "Datacenter"
  vsphere_compute_cluster        = "Cluster"
  vsphere_datastore              = "datastore1"
  vsphere_network                = "VM Network"
  vsphere_content_library        = "Templates"
  vsphere_content_library_item   = "ubuntu-24.04-template"
  vsphere_resource_pool          = "Resources"
  vsphere_root_folder            = "Kubernetes"
  vsphere_allow_unverified_ssl   = true
  vsphere_plus_license           = false

  # Network configuration
  dns_resolvers = ["8.8.8.8", "8.8.4.4"]

  # SSH configuration
  ssh_user             = "ubuntu"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
  ssh_private_key_path = "~/.ssh/id_rsa"
}

# Variables
variable "vsphere_username" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
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
  value       = module.vsphere_kamaji_node_pools.deployment_summary
}

output "node_details" {
  description = "Node details"
  value       = module.vsphere_kamaji_node_pools.vm_details
} 