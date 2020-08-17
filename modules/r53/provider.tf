# AWS network Provider Configuration
provider "aws" {
  alias  = "network"
  region = data.aws_region.current.name

  assume_role {
    role_arn = local.network_assume_role_arn
  }
}

locals {
  network_account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == "network"
  ].0
  network_assume_role_arn = "arn:aws:iam::${local.network_account_id}:role/OrganizationAccountAccessRole"
}

# AWS Master Provider Configuration
provider "aws" {
  alias  = "master"
  region = data.aws_region.current.name
}
