resource "aws_organizations_account" "backup" {
  # Backup Account
  name      = "backup"
  email     = "{EMAIL_PREFIX}+backup@{COMPANY_EMAIL_DOMAIN}"
  role_name = "OrganizationAccountAccessRole"

  parent_id = aws_organizations_organizational_unit.engineering.id

  iam_user_access_to_billing = "ALLOW"

  tags = {
    short_name  = "Backup"
    description = "{COMPANY_FULLNAME} Backup account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
