# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.0"
    }
  }
} 