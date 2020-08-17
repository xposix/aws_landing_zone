# AWS Provider Configuration
provider "aws" {
  region = var.region
}

variable "region" {
  # TO_FILL
  default = "eu-west-1"
}

# Audit AWS Provider Configuration
provider "aws" {
  alias  = "audit"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${local.non_master_account_ids["audit"]}:role/OrganizationAccountAccessRole"
  }
}
