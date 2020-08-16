locals {
  account_name = "network"

  account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == local.account_name
  ].0

  assume_role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"

  # TO_FILL
  gateway_prod_cidr = "10.1.0.0/23"
  # Full AWS range
  aws_cidr_range = "10.1.0.0/11"
}

variable "region" {
  # TO_FILL
  default = "eu-west-1"
}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
