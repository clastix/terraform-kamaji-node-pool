# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string 
  default     = "charlie"
}

# =============================================================================
# NODE POOL CONFIGURATION
# =============================================================================

variable "pool_name" {
  description = "Name of the node pool"
  type        = string
  default     = "default"
}

variable "pool_size" {
  description = "The size of the node pool"
  type        = number
  default     = 3
}

variable "runcmd" {
  description = "Command to run on the node at first boot time"
  type        = string
  default     = "echo 'Hello, World!'"
}

# =============================================================================
# NODE CONFIGURATION
# =============================================================================

variable "node_memory" {
  description = "Memory for each node in MB"
  type        = number
  default     = 4096
}

variable "node_cpus" {
  description = "Number of CPUs for each node"
  type        = number
  default     = 2
}

variable "node_cpu_cores" {
  description = "Number of CPU cores for each node"
  type        = number
  default     = 1
}

variable "node_disk_size" {
  description = "Disk size for each node in MB"
  type        = number
  default     = 12800
}

variable "node_disk_storage_profile" {
  description = "Storage profile for the node disks"
  type        = string
  default     = "example-storage-profile"
}

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

variable "vapp_network_name" {
  description = "Organization network name in VMware Cloud Director"
  type        = string
  default     = "example-org-network-name"
}

variable "vapp_network_adapter_type" {
  description = "Adapter type for the vApp network"
  type        = string
  default     = "VMXNET3"
}

variable "vapp_ip_allocation_mode" {
  description = "IP allocation mode for the vApp"
  type        = string
  default     = "POOL" 
}

# =============================================================================
# TEMPLATE CONFIGURATION
# =============================================================================

variable "vapp_template_name" {
  description = "Template name in VMware Cloud Director"
  type        = string
  default     = "example-template-name"
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for the nodes"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# =============================================================================
# VMWARE CLOUD DIRECTOR CONFIGURATION
# =============================================================================

variable "vcd_org_name" {
  description = "Organization name in VMware Cloud Director"
  type        = string
}

variable "vcd_vdc_name" {
  description = "Virtual Data Center name in VMware Cloud Director"
  type        = string
}

variable "vcd_catalog_org_name" {
  description = "Organization name for the vCloud catalog in VMware Cloud Director"
  type        = string
}

variable "vcd_catalog_name" {
  description = "Catalog name in VMware Cloud Director"
  type        = string
}

variable "vcd_logging" {
  description = "Enable logging for VMware Cloud Director provider"
  type        = bool
  default     = false
}