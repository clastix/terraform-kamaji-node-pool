# =============================================================================
# CLUSTER CONFIGURATION
# =============================================================================

# Tenant Cluster Configuration
variable "tenant_cluster_name" {
  description = "Name of the tenant cluster"
  type        = string
}

# =============================================================================
# POOL CONFIGURATION
# =============================================================================

variable "runcmd" {
  description = "Command to run on the node at first boot time"
  type        = string
  default     = "echo 'Hello, World!'"
}

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

# =============================================================================
# NETWORK CONFIGURATION
# =============================================================================

variable "network_cidr" {
  description = "The CIDR block for the network"
  type        = string
  default     = "10.10.10.0/24"
}

variable "network_gateway" {
  description = "The gateway for the network"
  type        = string
  default     = "10.10.10.1"
}

variable "network_offset" {
  description = "The offset for the network IP addresses"
  type        = number
  default     = 10
}

variable "dns_resolvers" {
  description = "The list of DNS resolver names for the nodes to use"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

# =============================================================================
# NODE CONFIGURATION
# =============================================================================

variable "node_scsi_type" {
  description = "The type of the SCSI device of the node"
  type        = string
  default     = "lsilogic"
}

variable "node_hardware_version" {
  description = "The hardware version of the virtual machine"
  type        = string
  default     = "19"
}

variable "node_firmware" {
  description = "The firmware type to boot the virtual machine"
  type        = string
  default     = "bios"
}

variable "node_disk_thin" {
  description = "Whether to thin-provision the disks of the node"
  type        = bool
  default     = false
}

variable "node_disk_size" {
  description = "The size in GiB of the disks of the node"
  type        = number
  default     = 16
}

variable "node_cores" {
  description = "The number of CPU cores for the node"
  type        = number
  default     = 4
}

variable "node_memory" {
  description = "The memory assigned to the node (in MB)"
  type        = number
  default     = 16384
}

variable "node_interface_name" {
  description = "The default route's interface name of the node"
  type        = string
  default     = "ens160"
}

variable "node_guest" {
  description = "The guest OS of the node"
  type        = string
  default     = "ubuntu64Guest"
}

# =============================================================================
# SSH CONFIGURATION
# =============================================================================

variable "ssh_user" {
  description = "The guest OS user to use to connect via SSH on the nodes"
  type        = string
  default     = "clastix"
}

variable "ssh_private_key_path" {
  description = "The path to the private SSH key to use to provision on the nodes"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  description = "The path to the public SSH key to use to provision on the nodes"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# =============================================================================
# VSPHERE CONFIGURATION
# =============================================================================

variable "vsphere_server" {
  description = "The vSphere server address"
  type        = string
  default     = "vsphere-server.example.com:443"
}

variable "vsphere_username" {
  description = "The username for vSphere"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "The password for vSphere"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "The vSphere datacenter name"
  type        = string
  default     = "DatacenterName"
}

variable "vsphere_compute_cluster" {
  description = "The vSphere compute cluster name"
  type        = string
  default     = "ComputeClusterName"
}

variable "vsphere_datastore" {
  description = "The vSphere datastore name"
  type        = string
  default     = "DatastoreName"
}

variable "vsphere_content_library" {
  description = "The vSphere content library name"
  type        = string
  default     = "ContentLibraryName"
}

variable "vsphere_content_library_item" {
  description = "The vSphere content library item name"
  type        = string
  default     = "ContentLibraryItemName"
}

variable "vsphere_resource_pool" {
  description = "The vSphere resource pool name"
  type        = string
  default     = "ResourcePoolName"
}

variable "vsphere_root_folder" {
  description = "The root folder where to place node pools"
  type        = string
  default     = ""
}

variable "vsphere_network" {
  description = "The vSphere network name"
  type        = string
  default     = "NetworkName"
}

variable "vsphere_plus_license" {
  description = "Set on/off based on your vSphere enterprise license"
  type        = bool
  default     = false
}