# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
}

variable "tenant_kubeconfig_path" {
  description = "Path to the tenant cluster kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "yaki_url" {
  description = "URL to the YAKI script for node bootstrapping"
  type        = string
  default     = "https://goyaki.clastix.io"
}

# =============================================================================
# NODE POOL CONFIGURATION
# =============================================================================

variable "node_pools" {
  description = "List of node pools with their configurations"
  type = list(object({
    name            = string
    size            = number
    network_cidr    = string
    network_gateway = string
    network_offset  = number
    vms_state       = string
    vms_agent       = number
    vms_memory      = number
    vms_sockets     = number
    vms_cores       = number
    vms_vcpus       = number
    vms_boot        = string
    vms_scsihw      = string
    vms_disk_size   = number
    vms_template    = string
  }))
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for cloud-init"
  type        = string
  default     = "clastix"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

variable "nameserver" {
  description = "DNS resolver for the nodes"
  type        = string
  default     = "8.8.8.8"
}

variable "search_domain" {
  description = "DNS search domain for the nodes"
  type        = string
  default     = ""
}

variable "network_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network model for VMs"
  type        = string
  default     = "virtio"
}

# =============================================================================
# PROXMOX CONFIGURATION
# =============================================================================

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox target node"
  type        = string
}

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox user"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "storage_disk" {
  description = "Storage disk for VMs"
  type        = string
  default     = "local"
}