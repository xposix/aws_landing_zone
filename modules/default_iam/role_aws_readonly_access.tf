## Create the role and assign assume policy
resource "aws_iam_role" "clz_aws_readonly_access" {
  count                = contains(var.roles, "clz_aws_readonly_access") ? 1 : 0
  name                 = "clz_aws_readonly_access"
  assume_role_policy   = data.aws_iam_policy_document.saml_federated_and_api_access_assume.json
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy_attachment" "clz_aws_readonly_access" {
  count      = contains(var.roles, "clz_aws_readonly_access") ? 1 : 0
  role       = aws_iam_role.clz_aws_readonly_access[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "restrictions_readonly" {
  count      = contains(var.roles, "clz_aws_readonly_access") ? 1 : 0
  role       = aws_iam_role.clz_aws_readonly_access[count.index].name
  policy_arn = aws_iam_policy.restrictions_readonly[count.index].arn
}

resource "aws_iam_policy" "restrictions_readonly" {
  count       = contains(var.roles, "clz_aws_readonly_access") ? 1 : 0
  name        = "clz_restrictions_readonly_policy"
  path        = "/"
  description = "Restricts AWS Config total access and only allows readonly Cloudtrail"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585652472561",
      "Action": "config:*",
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}
