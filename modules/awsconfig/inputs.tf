variable "name" {
  default = "awsconfig"
}

variable "bucket_name" {
  type = string
}

variable "bucket_prefix" {
  default = "v1"
}

variable "delivery_frequency" {
  default = "One_Hour"
}

variable "recorder_enabled" {
  default = true
}

variable "slack_channel" {
  default = "aws-alerts"
}

variable "slack_webhook_url" {
  default = "https://hooks.slack.com/services/TO_FILL"
}
