# TO_FILL
locals {
  # Account settings
  account_name  = "shared_services_live"
  dns_subdomain = "live.services"

  # IAM settings
  iam_roles_to_deploy = [
    "clz_clz_aws_admin_access",
    "clz_clz_aws_mini_admin_access",
    "clz_clz_aws_readonly_access"
  ]

  account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == local.account_name
  ].0
  assume_role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"

  network_account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == "network"
  ].0
  network_assume_role_arn = "arn:aws:iam::${local.network_account_id}:role/OrganizationAccountAccessRole"
}

locals {
  primary-region-vpc1 = {
    vpc_name = "vpc1"
    n_of_AZs = 2
    vpc_cidr = "10.1.0.0/22"
  }
}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
