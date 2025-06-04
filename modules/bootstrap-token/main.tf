# =============================================================================
# DATA SOURCES
# =============================================================================

# Read the kubeconfig file from the specified path
data "local_file" "tenant_kubeconfig" {
  filename = var.kubeconfig_path
}

# Extract the current Kubernetes server version
data "kubernetes_server_version" "current" {}

# Extract the API server endpoint from the cluster-info ConfigMap
data "kubernetes_config_map" "cluster_info" {
  metadata {
    name      = "cluster-info"
    namespace = "kube-public"
  }
}

# =============================================================================
# RANDOM TOKEN GENERATION
# =============================================================================

# Generate a random token ID
resource "random_string" "token_id" {
  length  = 6
  upper   = false
  special = false
}

# Generate a random token secret
resource "random_string" "token_secret" {
  length  = 16
  upper   = false
  special = false
}

# =============================================================================
# KUBERNETES BOOTSTRAP TOKEN
# =============================================================================

# Create the bootstrap token secret in the Kubernetes cluster
resource "kubernetes_secret" "bootstrap_token" {
  metadata {
    name      = "bootstrap-token-${random_string.token_id.result}"
    namespace = "kube-system"
  }

  data = {
    "token-id"                       = random_string.token_id.result
    "token-secret"                   = random_string.token_secret.result
    "usage-bootstrap-authentication" = "true"
    "usage-bootstrap-signing"        = "true"
    "auth-extra-groups"              = "system:bootstrappers:kubeadm:default-node-token"
    "expiration"                     = timeadd(timestamp(), "1h")
  }

  type = "bootstrap.kubernetes.io/token"

  # Ensure the token ID and secret are generated before creating the secret
  depends_on = [
    random_string.token_id,
    random_string.token_secret
  ]

  # Ensure the secret is recreated if it already exists
  lifecycle {
    create_before_destroy = true
  }
}

# =============================================================================
# JOIN COMMAND PREPARATION
# =============================================================================

# Prepare the join command for bootstrapping nodes
locals {
  # Decode the kubeconfig data from the cluster-info ConfigMap
  kubeconfig = yamldecode(data.kubernetes_config_map.cluster_info.data["kubeconfig"])

  # Extract the join URL from the kubeconfig
  join_url = replace(local.kubeconfig.clusters[0].cluster.server, "https://", "")

  # Combine the token ID and secret to form the join token
  join_token = "${random_string.token_id.result}.${random_string.token_secret.result}"

  # Format the Kubernetes version
  kubernetes_version = format("v%s", data.kubernetes_server_version.current.version)

  # Construct the join command for bootstrapping nodes
  join_cmd = "wget -O- ${var.yaki_url} | JOIN_URL=${local.join_url} JOIN_TOKEN=${local.join_token} KUBERNETES_VERSION=${local.kubernetes_version} bash -s join"
} 