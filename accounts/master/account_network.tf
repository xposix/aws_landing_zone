resource "aws_organizations_account" "network" {
  # Network Account
  name      = "network"
  email     = "{EMAIL_PREFIX}+network@{COMPANY_EMAIL_DOMAIN}"
  role_name = "OrganizationAccountAccessRole"

  parent_id = aws_organizations_organizational_unit.engineering.id

  iam_user_access_to_billing = "ALLOW"

  tags = {
    short_name  = "network"
    description = "{COMPANY_FULLNAME} Network account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
