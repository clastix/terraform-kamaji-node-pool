# =============================================================================
# JOIN COMMAND
# =============================================================================

output "join_cmd" {
  description = "Complete join command for bootstrapping nodes"
  value       = local.join_cmd
  sensitive   = true
} 