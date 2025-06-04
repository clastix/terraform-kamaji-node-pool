# =============================================================================
# DATA SOURCES
# =============================================================================

# Get datacenter information
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

# Get datastore for VM storage
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get network configuration
data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get content library for templates
data "vsphere_content_library" "content_library" {
  name = var.vsphere_content_library
}

# Get specific template/OVF from content library
data "vsphere_content_library_item" "item" {
  name       = var.vsphere_content_library_item
  type       = "ovf"
  library_id = data.vsphere_content_library.content_library.id
}

# Get compute cluster information
data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Get resource pool information
data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}
