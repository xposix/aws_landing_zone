data "aws_region" "current" {}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }

variable "main_r53_zone_name" {
  description = "Main zone name in the Network account"
  type        = string
}

variable "dns_subdomain" {
  description = "DNS Subdomain to assign to that account (usually a prefix based on the account name)"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "A key/value map containing tags to be added to all resources"
}

