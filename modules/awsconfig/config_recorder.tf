resource "aws_config_configuration_recorder" "awsconfig" {
  name     = var.name
  role_arn = aws_iam_role.awsconfig.arn
}

resource "aws_config_delivery_channel" "awsconfig" {
  name           = aws_config_configuration_recorder.awsconfig.name
  s3_bucket_name = var.bucket_name
  s3_key_prefix  = var.bucket_prefix

  snapshot_delivery_properties {
    delivery_frequency = var.delivery_frequency
  }

  sns_topic_arn = aws_sns_topic.default_slack.arn
}

resource "aws_config_configuration_recorder_status" "awsconfig" {
  name       = aws_config_delivery_channel.awsconfig.name
  is_enabled = var.recorder_enabled
}
