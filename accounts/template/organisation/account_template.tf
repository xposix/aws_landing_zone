resource "aws_organizations_account" "{ACCOUNT_NAME}" {
  # TO_FILL {ACCOUNT_NAME} Account
  name      = "{ACCOUNT_NAME}"
  email     = "aws+{ACCOUNT_NAME}@{COMPANY_EMAIL_DOMAIN}"
  role_name = "{ORGANISATIONS_DEPLOYER_ROLE}"

  iam_user_access_to_billing = "ALLOW"

  tags = {
    short_name  = "{ACCOUNT_NAME}"
    description = "TO_FILL {ACCOUNT_NAME} Account"
  }

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
