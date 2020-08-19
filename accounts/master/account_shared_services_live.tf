resource "aws_organizations_account" "shared_services_live" {
  # Shared Services Live Account
  name      = "shared_services_live"
  email     = "{EMAIL_PREFIX}+shared_services_live@{COMPANY_EMAIL_DOMAIN}"
  role_name = "OrganizationAccountAccessRole"

  parent_id = aws_organizations_organizational_unit.engineering.id

  iam_user_access_to_billing = "DENY"

  tags = {
    short_name  = "Shared Services Live"
    description = "{COMPANY_FULLNAME} Shared Services Live account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
