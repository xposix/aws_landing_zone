locals {
  account_name = "master"
  non_master_account_ids = {
    for a in data.aws_organizations_organization.my_organisation.non_master_accounts :
    a["name"] => a["id"]
  }
  account_id = data.aws_organizations_organization.my_organisation.master_account_id
}

data "aws_organizations_organization" "my_organisation" {}
