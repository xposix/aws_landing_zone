# TO_FILL
resource "aws_route53_delegation_set" "mycompany" {
  reference_name = "mycompany"
}

resource "aws_route53_zone" "mycompany" {
  name              = "mycompany.domain"
  delegation_set_id = aws_route53_delegation_set.mycompany.id
}

resource "aws_route53_record" "mycompany_google_verification" {
  zone_id = aws_route53_zone.mycompany.zone_id
  name    = "mycompany.domain"
  type    = "TXT"
  ttl     = "300"
  records = ["google-site-verification=Add_GOoGLe_SiTe_VeRiFiCaTiON_HeRE"]
}

output "mycompany_name" {
  value = aws_route53_zone.mycompany.name
}

output "mycompany_zone_id" {
  value = aws_route53_zone.mycompany.zone_id
}

output "mycompany_name_servers" {
  value = aws_route53_delegation_set.mycompany.name_servers
}
