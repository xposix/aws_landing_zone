## Create the role and assign assume policy
resource "aws_iam_role" "billing_admin" {
  count                = contains(var.roles, "billing_admin") ? 1 : 0
  name                 = "billing_admin"
  assume_role_policy   = data.aws_iam_policy_document.saml_federated_and_api_access_assume.json
  max_session_duration = var.max_session_duration
}

## Attach the policy json to the role
resource "aws_iam_role_policy_attachment" "billing_admin" {
  count  = contains(var.roles, "billing_admin") ? 1 : 0
  role       = aws_iam_role.billing_admin.0.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}
