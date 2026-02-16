# WHY: Print the Load Balancer URL so that it is easy to copy-paste to the webrowser
output "alb_dns_name" {
  description = "The public DNS name (URL) of the Load Balancer"
  value       = aws_lb.static_alb.dns_name
}