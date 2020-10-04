locals {
  account_name = "master"
  region       = "eu-west-1"
}

data "aws_organizations_organization" "my_organisation" {}
