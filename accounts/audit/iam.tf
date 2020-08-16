module "default_iam" {
  source = "../../modules/default_iam"

  aws_organizations_accounts = data.aws_organizations_organization.my_organisation.accounts

  roles = [
    "aws_admin_access",
    "aws_power_user_access",
    "aws_readonly_access"
  ]
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "mycompany-${replace(local.account_name, "_", "-")}"
}