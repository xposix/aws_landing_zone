## Create the role and assign assume policy
resource "aws_iam_role" "clz_aws_cicd_access" {
  name                 = "clz_aws_cicd_access"
  assume_role_policy   = data.aws_iam_policy_document.cc_api_access.json
  max_session_duration = var.max_session_duration
}

data "aws_iam_policy_document" "cc_api_access" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.lock_cicd_role_to_these_arns
    }

    actions = ["sts:AssumeRole"]
  }

}

## Adds Administrator Access
resource "aws_iam_role_policy_attachment" "clz_aws_cicd_access" {
  role       = aws_iam_role.clz_aws_cicd_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Removes the CLZ resources from it
resource "aws_iam_role_policy_attachment" "restrictions_aws_cicd" {
  role       = aws_iam_role.clz_aws_cicd_access.name
  policy_arn = aws_iam_policy.restrictions_aws_cicd.arn
}

resource "aws_iam_policy" "restrictions_aws_cicd" {
  name        = "clz_restrictions_aws_cicd_policy"
  path        = "/"
  description = "Protects the CLZ resources from misusage"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585655254541",
      "Action": [
        "lambda:AddLayerVersionPermission",
        "lambda:AddPermission",
        "lambda:CreateAlias",
        "lambda:CreateEventSourceMapping",
        "lambda:CreateFunction",
        "lambda:DeleteAlias",
        "lambda:DeleteEventSourceMapping",
        "lambda:DeleteFunction",
        "lambda:DeleteFunctionConcurrency",
        "lambda:DeleteFunctionEventInvokeConfig",
        "lambda:DeleteLayerVersion",
        "lambda:DeleteProvisionedConcurrencyConfig",
        "lambda:PutFunctionConcurrency",
        "lambda:PutFunctionEventInvokeConfig",
        "lambda:PutProvisionedConcurrencyConfig",
        "lambda:RemoveLayerVersionPermission",
        "lambda:RemovePermission",
        "lambda:TagResource",
        "lambda:UntagResource",
        "lambda:UpdateAlias",
        "lambda:UpdateEventSourceMapping",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:UpdateFunctionEventInvokeConfig"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:clz_*"
    },
    {
      "Sid": "Stmt1545672678463",
      "Action": [
        "iam:AddRoleToInstanceProfile",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:DeleteRolePermissionsBoundary",
        "iam:PassRole",
        "iam:TagRole",
        "iam:UntagRole",
        "iam:UpdateRole",
        "iam:UpdateRoleDescription",
        "iam:AttachGroupPolicy",
        "iam:AttachRolePolicy",
        "iam:AttachUserPolicy",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteUserPolicy",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/clz_*"
    },
    {
      "Sid": "Stmt1585672671463",
      "Action": [
        "iam:AttachGroupPolicy",
        "iam:AttachRolePolicy",
        "iam:AttachUserPolicy",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteUserPolicy",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy"
      ],
      "Effect": "Deny",
      "Resource": "*",
      "Condition": {
        "ArnLike": {
          "iam:PolicyARN": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/clz_*"
        }
      }
    },
    {
      "Sid": "Stmt151672671463",
      "Action": [
        "sns:AddPermission",
        "sns:ConfirmSubscription",
        "sns:CreatePlatformApplication",
        "sns:CreatePlatformEndpoint",
        "sns:CreateTopic",
        "sns:DeleteEndpoint",
        "sns:DeletePlatformApplication",
        "sns:DeleteTopic",
        "sns:RemovePermission",
        "sns:SetEndpointAttributes",
        "sns:SetPlatformApplicationAttributes",
        "sns:SetSMSAttributes",
        "sns:SetSubscriptionAttributes",
        "sns:SetTopicAttributes",
        "sns:Subscribe",
        "sns:TagResource",
        "sns:Unsubscribe",
        "sns:UntagResource"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:clz_*"
    }
  ]
}
EOF
}
