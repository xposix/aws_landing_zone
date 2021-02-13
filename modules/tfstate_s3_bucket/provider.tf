data "aws_organizations_organization" "my_organisation" { provider = aws.master }
data "aws_region" "current" {}

# AWS backup Provider Configuration
provider "aws" {
  alias  = "backup"
  region = var.backup_region

  assume_role {
    role_arn = local.backup_assume_role_arn
  }
}

# AWS Master Provider Configuration
provider "aws" {
  alias  = "master"
  region = data.aws_region.current.name
}
