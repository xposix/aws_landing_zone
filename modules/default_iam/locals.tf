locals {
  master_account_id = var.master_account_id == "" ? data.aws_organizations_organization.org.master_account_id : var.master_account_id
}

data "aws_organizations_organization" "org" {}
data "aws_caller_identity" "current" {}
