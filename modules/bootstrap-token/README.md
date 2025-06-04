# Bootstrap Token Module

Generates Kubernetes bootstrap tokens for joining worker nodes to Kamaji tenant clusters.

## Usage

```hcl
module "bootstrap_token" {
  source = "../../modules/bootstrap-token"

  kubeconfig_path = "~/.kube/tenant-cluster.kubeconfig"
  yaki_url        = "https://goyaki.clastix.io"  # optional
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `kubeconfig_path` | `string` | `"~/.kube/config"` | Path to kubeconfig file |
| `yaki_url` | `string` | `"https://goyaki.clastix.io"` | YAKI bootstrap script URL |

## Outputs

- `join_cmd` - Complete join command for nodes
- `token_id` - Bootstrap token ID
- `token_secret` - Bootstrap token secret
- `ca_cert_hash` - CA certificate hash
- `cluster_endpoint` - Kubernetes API server endpoint
- `yaki_url` - YAKI bootstrap script URL
- `kubeconfig_path` - Path to kubeconfig file
- `token_ttl` - Token time-to-live
- `token_usage` - Token usage description

## Requirements
