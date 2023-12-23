locals {
  management_account_id = var.management_account_id == "" ? data.aws_organizations_organization.org.management_account_id : var.management_account_id
}

data "aws_organizations_organization" "org" {}
data "aws_caller_identity" "current" {}
