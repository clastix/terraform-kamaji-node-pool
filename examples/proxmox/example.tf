# Example: Proxmox Provider Usage
# This example shows how to use the Proxmox provider wrapper

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

# Configure the Proxmox provider
provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_parallel     = 1
  pm_tls_insecure = true
  pm_log_enable   = false
  pm_timeout      = 600
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path = var.tenant_kubeconfig_path
}

# Use the Proxmox provider module
module "proxmox_kamaji_node_pools" {
  source = "../../providers/proxmox"

  # Cluster configuration
  tenant_cluster_name    = "my-proxmox-cluster"
  tenant_kubeconfig_path = "~/.kube/my-cluster.kubeconfig"
  yaki_url              = "https://goyaki.clastix.io"

  # Node pools configuration
  node_pools = [
    {
      name            = "workers"
      size            = 3
      network_cidr    = "192.168.100.0/24"
      network_gateway = "192.168.100.1"
      network_offset  = 20
      vms_state       = "started"
      vms_agent       = 1
      vms_memory      = 4096
      vms_sockets     = 1
      vms_cores       = 2
      vms_vcpus       = 2
      vms_boot        = "order=scsi0"
      vms_scsihw      = "virtio-scsi-single"
      vms_disk_size   = 20
      vms_template    = "ubuntu-noble"
    }
  ]

  # Proxmox configuration
  proxmox_host     = "my-proxmox-host.example.com"
  proxmox_node     = "pve-node1"
  proxmox_api_url  = var.proxmox_api_url
  proxmox_user     = var.proxmox_user
  proxmox_password = var.proxmox_password

  # Network configuration
  nameserver      = "8.8.8.8"
  search_domain   = ""
  storage_disk    = "local-lvm"
  network_bridge  = "vmbr0"
  network_model   = "virtio"

  # SSH configuration
  ssh_user             = "ubuntu"
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"
}

# Variables
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://my-proxmox-host:8006/api2/json"
}

variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
  default     = "terraform@pam"
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "tenant_kubeconfig_path" {
  description = "Path to tenant cluster kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

# Outputs
output "deployment_summary" {
  description = "Deployment summary"
  value       = module.proxmox_kamaji_node_pools.deployment_summary
}

output "vm_details" {
  description = "VM details"
  value       = module.proxmox_kamaji_node_pools.vm_details
} 