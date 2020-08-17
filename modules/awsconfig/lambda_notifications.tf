resource "aws_cloudwatch_log_group" "lambda_slack" {
  name              = "/aws/lambda/clz_slack_notification"
  retention_in_days = 30
}

resource "aws_kms_key" "lambda_slack" {
  description             = "This key is used to encrypt slack webhook"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "lambda_slack" {
  name          = "alias/clz_slack_notification"
  target_key_id = aws_kms_key.lambda_slack.key_id
}

resource "aws_kms_ciphertext" "lambda_slack_webhook_url" {
  key_id = aws_kms_key.lambda_slack.key_id

  plaintext = var.slack_webhook_url
}

resource "aws_lambda_permission" "lambda_slack" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_slack.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.default_slack.arn
}

resource "aws_lambda_function" "lambda_slack" {
  filename      = "${path.module}/.tmp/clz_slack_notification.zip"
  function_name = "clz_slack_notification"
  role          = aws_iam_role.lambda_slack.arn
  handler       = "clz_slack_notification.lambda_handler"

  timeout = 10

  source_code_hash = data.archive_file.lambda_slack_py.output_base64sha256

  runtime = "python3.7"

  environment {
    variables = {
      slackChannel        = var.slack_channel
      kmsEncryptedHookUrl = aws_kms_ciphertext.lambda_slack_webhook_url.ciphertext_blob
    }
  }
}

data "archive_file" "lambda_slack_py" {
  type        = "zip"
  source_file = "${path.module}/clz_slack_notification.py"
  output_path = "${path.module}/.tmp/clz_slack_notification.zip"
}
