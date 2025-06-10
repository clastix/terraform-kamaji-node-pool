# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
  }
}

# =============================================================================
# NETWORK SECURITY GROUP CONFIGURATION
# =============================================================================

# Network Security Group for Kubernetes Nodes
resource "azurerm_network_security_group" "kubernetes" {
  name                = "${var.tenant_cluster_name}-${var.pool_name}-nsg"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name

  tags = merge(
    {
      "Name" = "${var.tenant_cluster_name}-${var.pool_name}"
    },
    var.tags,
  )
}

# Allow outgoing connectivity
resource "azurerm_network_security_rule" "allow_all_outbound" {
  name                        = "AllowAllOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.azure_resource_group_name
  network_security_group_name = azurerm_network_security_group.kubernetes.name
}

# Allow SSH access
resource "azurerm_network_security_rule" "allow_ssh_inbound" {
  name                        = "AllowSSHInbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.azure_resource_group_name
  network_security_group_name = azurerm_network_security_group.kubernetes.name
}

# Allow cluster internal communication
resource "azurerm_network_security_rule" "allow_cluster_internal" {
  name                        = "AllowClusterInternal"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.vnet_subnet_address_prefix
  destination_address_prefix  = var.vnet_subnet_address_prefix
  resource_group_name         = var.azure_resource_group_name
  network_security_group_name = azurerm_network_security_group.kubernetes.name
}

# =============================================================================
# VIRTUAL MACHINE SCALE SET
# =============================================================================

resource "azurerm_linux_virtual_machine_scale_set" "nodes" {
  name                = "${var.tenant_cluster_name}-${var.pool_name}-${var.enable_autoscaling ? "auto" : "manual"}-vmss"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_location
  sku                 = var.vm_size
  instances           = var.pool_size

  admin_username                  = var.ssh_user
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  os_disk {
    storage_account_type = var.node_disk_type
    caching              = "ReadWrite"
    disk_size_gb         = var.node_disk_size
  }

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "primary"
      primary   = true
      subnet_id = data.azurerm_subnet.tenant_subnet.id

      dynamic "public_ip_address" {
        for_each = var.assign_public_ip ? [1] : []
        content {
          name = "primary"
        }
      }
    }

    network_security_group_id = azurerm_network_security_group.kubernetes.id
  }

  custom_data = data.cloudinit_config.node_cloud_init.rendered

  # Configure upgrade policy
  upgrade_mode = var.upgrade_mode

  tags = merge(
    {
      "Name" = "${var.tenant_cluster_name}-${var.pool_name}"
    },
    var.tags,
  )
}

# =============================================================================
# AUTO SCALING CONFIGURATION
# =============================================================================

resource "azurerm_monitor_autoscale_setting" "nodes" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = "${var.tenant_cluster_name}-${var.pool_name}-autoscale"
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.nodes.id

  profile {
    name = "AutoScale"

    capacity {
      default = var.pool_size
      minimum = var.pool_min_size
      maximum = var.pool_max_size
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.nodes.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.nodes.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  tags = var.tags
} 