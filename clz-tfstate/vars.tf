# AWS Provider Configuration
provider "aws" {
  region = local.primary_region
}

# BACKUP AWS Provider Configuration
provider "aws" {
  alias  = "backup"
  region = local.backup_region

  assume_role {
    role_arn = "arn:aws:iam::${local.backup_account}:role/OrganizationAccountAccessRole"
  }
}

variable "tags" {
  type = map

  default = {
    Name        = "terraform_state_landing_zone_aws"
    Repo        = "github.com/xposix/aws_landing_zone"
    Environment = "production"
  }
}

locals {
  primary_account = "TO_FILL"
  primary_region  = "eu-west-1"
  backup_account  = "TO_FILL"
  backup_region   = "eu-west-2"
}
