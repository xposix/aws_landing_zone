resource "aws_organizations_account" "backup" {
  # Backup Account
  name      = "backup"
  email     = "aws+backup@{COMPANY_EMAIL_DOMAIN}"
  role_name = "OrganizationAccountAccessRole"

  parent_id = aws_organizations_organizational_unit.engineering.id

  iam_user_access_to_billing = "DENY"

  tags = {
    short_name  = "backup"
    description = "My Company backup Account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
