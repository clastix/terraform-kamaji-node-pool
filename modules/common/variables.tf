# Tenant Cluster Configuration
variable "tenant_cluster_config" {
  description = "Tenant cluster configuration"
  type = object({
    name            = string
    kubeconfig_path = string
  })
  validation {
    condition     = length(var.tenant_cluster_config.name) > 0
    error_message = "Tenant cluster name cannot be empty."
  }
}

# SSH Configuration
variable "ssh_config" {
  description = "SSH configuration for node access"
  type = object({
    user             = string
    public_key_path  = string
    private_key_path = optional(string, "")
  })
  validation {
    condition     = length(var.ssh_config.user) > 0
    error_message = "SSH user cannot be empty."
  }
}

# Node Pool Configuration
variable "node_pool_config" {
  description = "Node pool configuration"
  type = object({
    name     = string
    size     = number
    min_size = optional(number, 1)
    max_size = optional(number, 10)
  })
  validation {
    condition     = var.node_pool_config.size >= var.node_pool_config.min_size
    error_message = "Pool size must be greater than or equal to min_size."
  }
  validation {
    condition     = var.node_pool_config.size <= var.node_pool_config.max_size
    error_message = "Pool size must be less than or equal to max_size."
  }
}

# Bootstrap Configuration
variable "bootstrap_config" {
  description = "Bootstrap configuration"
  type = object({
    yaki_url = optional(string, "https://goyaki.clastix.io")
  })
} 