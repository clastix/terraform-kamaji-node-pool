# =============================================================================
# AUTO SCALING GROUP
# =============================================================================

output "autoscaling_group_details" {
  description = "Auto Scaling Group details"
  value = {
    name             = aws_autoscaling_group.nodes.name
    arn              = aws_autoscaling_group.nodes.arn
    min_size         = aws_autoscaling_group.nodes.min_size
    max_size         = aws_autoscaling_group.nodes.max_size
    desired_capacity = aws_autoscaling_group.nodes.desired_capacity
  }
}

# =============================================================================
# LAUNCH TEMPLATE
# =============================================================================

output "launch_template_details" {
  description = "Launch Template details"
  value = {
    id            = aws_launch_template.nodes.id
    name          = aws_launch_template.nodes.name
    ami_id        = aws_launch_template.nodes.image_id
    instance_type = aws_launch_template.nodes.instance_type
  }
} 