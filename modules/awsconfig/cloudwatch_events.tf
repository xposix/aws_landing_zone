resource "aws_cloudwatch_event_rule" "ec2_events" {
  name        = "ec2_events"
  description = "Capture EC2 events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "ec2_events_sns" {
  rule      = aws_cloudwatch_event_rule.ec2_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.default_slack.arn
}

resource "aws_cloudwatch_event_rule" "autoscaling_events" {
  name        = "autoscaling_events"
  description = "Capture autoscaling events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "autoscaling_events_sns" {
  rule      = aws_cloudwatch_event_rule.autoscaling_events.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.default_slack.arn
}

# resource "aws_cloudwatch_event_rule" "config_events" {
#   name        = "config_events"
#   description = "Capture config events"
#
#   event_pattern = <<PATTERN
# {
#   "source": [
#     "aws.config"
#   ],
#   "detail-type": [
#     "Config Rules Compliance Change"
#   ]
# }
# PATTERN
# }
#
# resource "aws_cloudwatch_event_target" "config_events_sns" {
#   rule      = aws_cloudwatch_event_rule.config_events.name
#   target_id = "SendToSNS"
#   arn       = aws_sns_topic.default_slack.arn
# }
