# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
}

variable "pool_name" {
  description = "Name of the node pool"
  type        = string
  default     = "default"
}

variable "pool_size" {
  description = "Number of nodes in the pool"
  type        = number
  default     = 3
}

variable "runcmd" {
  description = "Command to run on nodes at first boot"
  type        = string
  default     = "echo 'Hello, World!'"
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "SSH user for node access"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

variable "network_cidr" {
  description = "CIDR block for the network"
  type        = string
  default     = "10.10.10.0/24"
}

variable "network_gateway" {
  description = "Network gateway address"
  type        = string
  default     = "10.10.10.1"
}

variable "network_offset" {
  description = "IP address offset for nodes"
  type        = number
  default     = 10
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
}

variable "network_model" {
  description = "Network interface model"
  type        = string
  default     = "virtio"
}

variable "nameserver" {
  description = "DNS resolver for nodes"
  type        = string
  default     = "8.8.8.8"
}

variable "search_domain" {
  description = "DNS search domain"
  type        = string
}

# =============================================================================
# VM CONFIGURATION
# =============================================================================

variable "vms_template" {
  description = "VM template name"
  type        = string
}

variable "vms_state" {
  description = "Desired VM state"
  type        = string
  default     = "started"
}

variable "vms_agent" {
  description = "Enable QEMU Guest Agent (1=enabled, 0=disabled)"
  type        = number
  default     = 1
}

# CPU Configuration
variable "vms_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "vms_cores" {
  description = "CPU cores per socket"
  type        = number
  default     = 2
}

variable "vms_vcpus" {
  description = "Number of vCPUs (0 = auto: sockets * cores)"
  type        = number
  default     = 0
}

# Memory Configuration
variable "vms_memory" {
  description = "Memory allocation in MB"
  type        = number
  default     = 1024
}

# Boot Configuration
variable "vms_boot" {
  description = "Boot order (must match template OS disk)"
  type        = string
  default     = "order=scsi0"
}

variable "vms_scsihw" {
  description = "SCSI controller type"
  type        = string
  default     = "virtio-scsi-single"
}

# Disk Configuration
variable "storage_disk" {
  description = "Storage location for VM disks"
  type        = string
  default     = "local"
}

variable "vms_disk_size" {
  description = "VM disk size in GB"
  type        = number
  default     = 16
}

# =============================================================================
# PROXMOX SERVER CONFIGURATION
# =============================================================================

variable "proxmox_host" {
  description = "Proxmox server hostname/IP"
  type        = string
}

variable "proxmox_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "proxmox_api_url" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox authentication user"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox user password"
  type        = string
  sensitive   = true
}