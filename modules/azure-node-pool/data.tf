# =============================================================================
# DATA SOURCES
# =============================================================================

data "azurerm_resource_group" "tenant" {
  name = var.azure_resource_group_name
}

data "azurerm_virtual_network" "tenant_vnet" {
  name                = var.azure_vnet_name
  resource_group_name = var.azure_resource_group_name
}

data "azurerm_subnet" "tenant_subnet" {
  name                 = var.azure_subnet_name
  virtual_network_name = var.azure_vnet_name
  resource_group_name  = var.azure_resource_group_name
}

# =============================================================================
# CLOUD-INIT CONFIGURATION
# =============================================================================

data "cloudinit_config" "node_cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../templates/cloud-init/userdata.yml.tpl", {
      hostname       = ""
      runcmd         = var.runcmd
      ssh_user       = var.ssh_user
      ssh_public_key = file(pathexpand(var.ssh_public_key_path))
    })
  }
} 