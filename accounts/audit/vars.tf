locals {
  account_name = "audit"

  account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == local.account_name
  ].0

  assume_role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
}

variable "region" {
  default = "eu-west-1"
}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
