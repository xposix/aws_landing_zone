module "dns" {
  source             = "../../modules/r53"
  main_r53_zone_name = local.company_dns_domain
  dns_subdomain      = local.dns_subdomain
  project_tags       = local.project_tags
}

output "dns_servers" {
  description = "The DNS servers created for each delegated zone"
  value       = module.dns.delegated_zones_ns
}
