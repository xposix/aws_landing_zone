module "default_iam" {
  source = "../../modules/default_iam"

  aws_organizations_accounts = data.aws_organizations_organization.my_organisation.accounts

  roles = local.iam_roles_to_deploy
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "mycompany-${replace(local.account_name, "_", "-")}"
}
