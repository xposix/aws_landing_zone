## Create the role and assign assume policy
resource "aws_iam_role" "aws_mini_admin_access" {
  count                = contains(var.roles, "aws_mini_admin_access") ? 1 : 0
  name                 = "aws_mini_admin_access"
  assume_role_policy   = data.aws_iam_policy_document.saml_federated_and_api_access_assume.json
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy_attachment" "aws_mini_admin_access" {
  count      = contains(var.roles, "aws_mini_admin_access") ? 1 : 0
  role       = aws_iam_role.aws_mini_admin_access[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "restrictions_mini_admin" {
  count      = contains(var.roles, "aws_mini_admin_access") ? 1 : 0
  role       = aws_iam_role.aws_mini_admin_access[count.index].name
  policy_arn = aws_iam_policy.restrictions_mini_admin[count.index].arn
}

resource "aws_iam_policy" "restrictions_mini_admin" {
  count       = contains(var.roles, "aws_mini_admin_access") ? 1 : 0
  name        = "restrictions_mini_admin_policy"
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
    },
    {
      "Sid": "Stmt1585652556928",
      "Action": [
        "cloudtrail:AddTags",
        "cloudtrail:CreateTrail",
        "cloudtrail:DeleteTrail",
        "cloudtrail:RemoveTags",
        "cloudtrail:StartLogging",
        "cloudtrail:StopLogging",
        "cloudtrail:UpdateTrail"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/clz_*"
    },
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
