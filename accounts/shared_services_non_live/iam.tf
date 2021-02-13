module "default_iam" {
  source = "../../modules/default_iam"

  aws_organizations_accounts = data.aws_organizations_organization.my_organisation.accounts

  # TO_FILL
  roles = [
    "clz_aws_admin_access",
    "clz_aws_power_user_access",
    "clz_aws_readonly_access"
  ]
}

resource "aws_iam_account_alias" "alias" {
  # TO_FILL
  account_alias = "{COMPANY_PREFIX}-${replace(local.account_name, "_", "-")}"
}
