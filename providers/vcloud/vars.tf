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
  description = "List of vApp node pools with their configurations"
  type = list(object({
    name                      = string # Name of the node pool
    size                      = number # Number of nodes in the pool
    node_disk_size            = number # Disk size for each node (in GB)
    node_disk_storage_profile = string # Storage profile for node disks
    node_cpus                 = number # Number of CPUs for each node
    node_cpu_cores            = number # Number of CPU cores for each node
    node_memory               = number # Memory for each node (in MB)
    network_name              = string # Network name for the node pool
    network_adapter_type      = string # Network adapter type
    ip_allocation_mode        = string # IP allocation mode (DHCP/Static)
    template_name             = string # vApp template name
  }))
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
# VMWARE CLOUD DIRECTOR CONFIGURATION
# =============================================================================

variable "vcd_url" {
  description = "VMware Cloud Director API endpoint URL"
  type        = string
}

variable "vcd_username" {
  description = "VMware Cloud Director username for authentication"
  type        = string
  sensitive   = true
}

variable "vcd_password" {
  description = "VMware Cloud Director password for authentication"
  type        = string
  sensitive   = true
}

variable "vcd_org_name" {
  description = "VMware Cloud Director organization name"
  type        = string
}

variable "vcd_vdc_name" {
  description = "VMware Cloud Director virtual data center name"
  type        = string
}

variable "vcd_catalog_org_name" {
  description = "Organization name for the vCloud catalog access"
  type        = string
}

variable "vcd_catalog_name" {
  description = "VMware Cloud Director catalog name containing templates"
  type        = string
}

variable "vcd_allow_insecure" {
  description = "Allow unverified SSL certificates (not recommended for production)"
  type        = bool
  default     = false
}

variable "vcd_logging" {
  description = "Enable debug logging for VMware Cloud Director provider"
  type        = bool
  default     = false
}