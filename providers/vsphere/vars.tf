# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
}

variable "tenant_kubeconfig_path" {
  description = "Path to the kubeconfig file for the tenant cluster"
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
  description = "List of vSphere node pools with their configurations"
  type = list(object({
    name            = string # Name of the node pool
    size            = number # Number of nodes in the pool
    node_disk_size  = number # Disk size for each node (in GB)
    node_cores      = number # Number of CPU cores for each node
    node_memory     = number # Memory for each node (in MB)
    node_guest      = string # Guest OS type for each node
    network_cidr    = string # Network CIDR for the node pool
    network_gateway = string # Network gateway for the node pool
    network_offset  = number # Network offset for the node pool
  }))
}

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

variable "dns_resolvers" {
  description = "List of DNS resolver addresses for the nodes"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for cloud-init and node access"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for node access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key for node provisioning"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# =============================================================================
# VSPHERE CONFIGURATION
# =============================================================================

variable "vsphere_server" {
  description = "vSphere server address (vCenter or ESXi host)"
  type        = string
}

variable "vsphere_username" {
  description = "vSphere username for authentication"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password for authentication"
  type        = string
  sensitive   = true
}

variable "vsphere_allow_unverified_ssl" {
  description = "Allow unverified SSL certificates (not recommended for production)"
  type        = bool
  default     = false
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter name where resources will be created"
  type        = string
}

variable "vsphere_compute_cluster" {
  description = "vSphere compute cluster name for VM placement"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere datastore name for VM storage"
  type        = string
}

variable "vsphere_network" {
  description = "vSphere network name for VM network connectivity"
  type        = string
}

variable "vsphere_content_library" {
  description = "vSphere content library name containing VM templates"
  type        = string
}

variable "vsphere_content_library_item" {
  description = "vSphere content library item name (VM template)"
  type        = string
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool name for VM resource allocation"
  type        = string
  default     = "Resources"
}

variable "vsphere_root_folder" {
  description = "Root folder path where node pool folders will be created"
  type        = string
  default     = "Kubernetes"
}

variable "vsphere_plus_license" {
  description = "Enable vSphere Enterprise Plus features (DRS anti-affinity rules)"
  type        = bool
  default     = false
}