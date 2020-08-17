resource "aws_sns_topic" "default_slack" {
  name = "clz_default_slack_notifications_topic"
}

resource "aws_sns_topic_subscription" "default_slack_sns_to_lambda" {
  topic_arn = aws_sns_topic.default_slack.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_slack.arn
}

resource "aws_sns_topic_policy" "default_slack" {
  arn    = aws_sns_topic.default_slack.arn
  policy = data.aws_iam_policy_document.sns_default_slack.json
}

data "aws_iam_policy_document" "sns_default_slack" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "config.amazonaws.com",
        "cloudwatch.amazonaws.com",
      ]
    }

    resources = [aws_sns_topic.default_slack.arn]
  }
}
