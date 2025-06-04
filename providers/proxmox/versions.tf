# =============================================================================
# TERRAFORM VERSIONS
# =============================================================================

terraform {
  required_providers {
    # https://github.com/telmate/terraform-provider-proxmox
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}