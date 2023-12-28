# data "aws_organizations_organization" "my_organisation" { provider = aws.master }
data "aws_region" "current" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [
        aws.remote_account,
        aws.master
      ]
    }
  }
}
