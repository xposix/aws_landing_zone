resource "aws_iam_role" "lambda_slack" {
  name = "clz_lambda_slack"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_slack" {
  name        = "clz_slack_notifications"
  path        = "/"
  description = "lambda_slack function's role permission for the kms:Decrypt action"

  policy = data.aws_iam_policy_document.lambda_slack.json
}

data "aws_iam_policy_document" "lambda_slack" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [aws_kms_key.lambda_slack.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    resources = [aws_sns_topic.default_slack.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.lambda_slack.arn}:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:ListAccountAliases",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy_attachment" "lambda_slack" {
  name       = "clz_slack_notification"
  roles      = [aws_iam_role.lambda_slack.name]
  policy_arn = aws_iam_policy.lambda_slack.arn
}
