# AWS Provider Configuration
provider "aws" {
  region = var.primary_region
}

# Audit AWS Provider Configuration
provider "aws" {
  alias  = "audit"
  region = var.primary_region

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.audit.id}:role/OrganizationAccountAccessRole"
  }
}
