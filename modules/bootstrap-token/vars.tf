# =============================================================================
# KUBERNETES CONFIGURATION
# =============================================================================

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

# =============================================================================
# BOOTSTRAP CONFIGURATION
# =============================================================================

variable "yaki_url" {
  description = "URL to the YAKI bootstrap script"
  type        = string
  default     = "https://goyaki.clastix.io"
} 