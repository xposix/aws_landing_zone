data "aws_route53_zone" "selected" {
  provider = aws.network
  name     = var.main_r53_zone_name
}

resource "aws_route53_zone" "delegated_zones" {
  name = "${var.dns_subdomain}.${var.main_r53_zone_name}"
  tags = var.project_tags
}

resource "aws_route53_record" "delegation-ns" {
  provider = aws.network

  allow_overwrite = true
  name            = "${var.dns_subdomain}.${var.main_r53_zone_name}"
  ttl             = 300
  type            = "NS"
  zone_id         = data.aws_route53_zone.selected.zone_id

  records = [
    aws_route53_zone.delegated_zones.name_servers.0,
    aws_route53_zone.delegated_zones.name_servers.1,
    aws_route53_zone.delegated_zones.name_servers.2,
    aws_route53_zone.delegated_zones.name_servers.3,
  ]
}
