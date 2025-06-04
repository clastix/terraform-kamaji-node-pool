# =============================================================================
# PROVIDERS
# =============================================================================

# Configure the Kubernetes provider
provider "kubernetes" {
  # Path to the kubeconfig file for accessing the tenant cluster
  config_path = var.tenant_kubeconfig_path
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# =============================================================================
# BOOTSTRAP TOKEN
# =============================================================================

# Call the shared bootstrap-token module to generate the join command
module "bootstrap_token" {
  source          = "../../modules/bootstrap-token" # Updated to use shared module
  kubeconfig_path = var.tenant_kubeconfig_path      # Pass the kubeconfig path to the module
  yaki_url        = var.yaki_url                    # Pass the YAKI URL to the module
}

# =============================================================================
# NODE POOLS
# =============================================================================

module "aws_node_pools" {
  source = "../../modules/aws-node-pool" # Updated path to the aws-node-pool module

  # Iterate over the list of node pools and call the module for each pool
  for_each = { for pool in var.node_pools : pool.name => pool }

  # Tenant cluster configuration
  tenant_cluster_name = var.tenant_cluster_name

  # Pool configuration
  pool_name     = each.value.name
  pool_size     = each.value.size
  pool_min_size = each.value.min_size
  pool_max_size = each.value.max_size

  # Node configuration
  node_disk_size = each.value.node_disk_size
  node_disk_type = each.value.disk_type

  # AWS configuration
  aws_region    = var.aws_region
  aws_zones     = var.aws_zones
  aws_vpc_name  = var.aws_vpc_name
  instance_type = each.value.instance_type
  ami_id        = each.value.ami_id
  public        = each.value.public
  tags          = var.tags

  # SSH configuration
  ssh_user            = var.ssh_user
  ssh_public_key_path = var.ssh_public_key_path

  # Join command for bootstrapping nodes
  runcmd = module.bootstrap_token.join_cmd

  # Ensure the aws-node-pool module depends on the bootstrap-token module
  depends_on = [
    module.bootstrap_token
  ]
}