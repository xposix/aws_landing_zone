module "default_iam" {
  source = "../../modules/default_iam"

  aws_organizations_accounts = aws_organizations_organization.my_organisation.non_master_accounts

  # TO_FILL
  roles = [
    "aws_admin_access",
    "aws_power_user_access",
    "aws_readonly_access",
    "billing_admin",
  ]
}

resource "aws_iam_account_alias" "alias" {
  # TO_FILL
  account_alias = "{COMPANY_PREFIX}-${replace(local.account_name, "_", "-")}"
}
