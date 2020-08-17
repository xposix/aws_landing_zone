resource "aws_organizations_account" "master" {
  # Master account
  name      = "master"
  email     = "aws+master@{COMPANY_EMAIL_DOMAIN}"

  # iam_user_access_to_billing = "ALLOW"

  tags = {
    short_name     = "master"
    description    = "My Company Master account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
