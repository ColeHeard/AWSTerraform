###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
### Outputs - Reference
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<
output "aws_instance_public_dns" {
  value       = aws_lb.primary-lb.dns_name
  description = "Public DNS for the load balancer."
}