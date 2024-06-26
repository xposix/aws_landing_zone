resource "aws_cloudwatch_log_group" "cloudtrail_management_global_org" {
  name = "cloudtrail_management_global_org"

  kms_key_id        = aws_kms_alias.cloudtrail_management_global_org.target_key_arn
  retention_in_days = 180
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs" {
  name = "cloudtrail_cloudwatch_logs"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch_logs" {
  name = "cloudtrail_cloudwatch_logs"
  role = aws_iam_role.cloudtrail_cloudwatch_logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.cloudtrail_management_global_org.arn}:*"
      ]
    }
  ]
}
POLICY
}
