# AWS Provider Configuration
provider "aws" {
  region = local.region
}

# Audit AWS Provider Configuration
provider "aws" {
  alias  = "audit"
  region = local.region

  assume_role {
    role_arn = "arn:aws:iam::${local.non_master_account_ids["audit"]}:role/OrganizationAccountAccessRole"
  }
}
