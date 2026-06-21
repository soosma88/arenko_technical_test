output "nginx_alb_dns_name" {
  description = "The Public DNS name of the nginx public load balancer"
  value       = aws_lb.nginx_alb.dns_name
}
