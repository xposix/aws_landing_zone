resource "aws_organizations_organization" "my_organisation" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "ram.amazonaws.com",
  ]

  feature_set = "ALL"
}

output "non_management_accounts" {
  value = aws_organizations_organization.my_organisation.non_management_accounts
}

output "management_account_id" {
  value = aws_organizations_organization.my_organisation.management_account_id
}
