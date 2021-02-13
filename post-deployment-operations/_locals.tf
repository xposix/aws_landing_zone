locals {
  region           = "eu-west-1"
  secondary_region = "eu-west-2"

  backup_account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == "backup"
  ].0
}
