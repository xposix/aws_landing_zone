## Create the role and assign assume policy
resource "aws_iam_role" "aws_admin_access" {
  count                = contains(var.roles, "aws_admin_access") ? 1 : 0
  name                 = "aws_admin_access"
  assume_role_policy   = data.aws_iam_policy_document.saml_federated_and_api_access_assume.json
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy_attachment" "aws_admin_access" {
  count      = contains(var.roles, "aws_admin_access") ? 1 : 0
  role       = aws_iam_role.aws_admin_access[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
