# AWS Provider Configuration
provider "aws" {
  region = var.primary_region
}

data "aws_organizations_organization" "my_organisation" {}
data "aws_caller_identity" "primary_account" {}

locals {
  account_name = "backup"

  backup_account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == local.account_name
  ].0
}

# BACKUP AWS Provider Configuration
provider "aws" {
  alias  = "backup"
  region = var.backup_region

  assume_role {
    role_arn = "arn:aws:iam::${local.backup_account_id}:role/OrganizationAccountAccessRole"
  }
}
