# ---compute/outputs.tf ---

output "instance" {
  value     = aws_instance.dev_instance[*]
  sensitive = true
}

output "instance_port" {
  value = aws_lb_target_group_attachment.dev_tg_attach[0].port
}