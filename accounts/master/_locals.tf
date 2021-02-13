data "aws_caller_identity" "current" {}

locals {
  account_name = "master"
  region       = "eu-west-1"
}
