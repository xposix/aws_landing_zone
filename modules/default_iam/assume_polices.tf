data "aws_iam_policy_document" "saml_federated_and_api_access_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.enable_saml_provider ? aws_iam_saml_provider.idp[0].arn : var.saml_provider_arn]
    }

    actions = ["sts:AssumeRoleWithSAML"]

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
