
output "delegated_zones_ns" {
  description = "Name Servers of the created delegated zones"
  value       = aws_route53_zone.delegated_zones
}

