# =============================================================================
# TERRAFORM BACKEND
# =============================================================================

terraform {
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}

# Alternative: Remote backend
# terraform {
#   backend "remote" {
#     organization = "organization"
#     workspaces {
#       name = "demo"
#     }
#   }
# }
