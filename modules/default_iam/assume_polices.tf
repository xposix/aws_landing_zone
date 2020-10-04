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

  # statement {
  #   effect = "Allow"

  #   principals {
  #     type        = "AWS"
  #     identifiers = concat(["arn:aws:iam::${local.master_account_id}:root"], var.assume_by_arns)
  #   }

  #   actions = ["sts:AssumeRole"]
  # }

  # statement {
  #   effect = "Allow"

  #   principals {
  #     type        = "Federated"
  #     identifiers = ["accounts.google.com"]
  #   }

  #   actions = ["sts:AssumeRoleWithWebIdentity"]

  #   condition {
  #     test     = "StringEquals"
  #     variable = "accounts.google.com:aud"

  #     values = [
  #       var.google_oauth_client_id,
  #     ]
  #   }
  # }
}

# data "aws_iam_policy_document" "sts_assume" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${local.master_account_id}:root"]
#     }

#     actions = ["sts:AssumeRole"]

#     condition {
#       test     = "Bool"
#       variable = "aws:MultiFactorAuthPresent"
#       values   = [true]
#     }
#   }
# }

# data "aws_iam_policy_document" "sts_assume_no_mfa" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${local.master_account_id}:root"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# data "aws_iam_policy_document" "glue_assume" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["glue.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# data "aws_iam_policy_document" "api_access" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = concat(["arn:aws:iam::${local.master_account_id}:root"], var.assume_by_arns)
#     }

#     actions = ["sts:AssumeRole"]
#   }

#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Federated"
#       identifiers = ["accounts.google.com"]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "accounts.google.com:aud"

#       values = [
#         var.google_oauth_client_id,
#       ]
#     }
#   }
# }

# data "aws_iam_policy_document" "lambda_assume" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }
