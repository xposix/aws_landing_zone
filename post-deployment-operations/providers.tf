locals {
  account_ids = {
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["name"] => a["id"]
  }
}

output "account_ids" {
  value = local.account_ids
}

provider "aws" {
  region = local.region
}


provider "aws" {
  region = local.region
  alias  = "shared_services_live"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["shared_services_live"]}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region = local.region
  alias  = "shared_services_non_live"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["shared_services_non_live"]}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region = local.region
  alias  = "sandbox"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_ids["sandbox"]}:role/OrganizationAccountAccessRole"
  }
}

# AWS Backup Account Provider Configuration
provider "aws" {
  alias  = "backup_primary_region"
  region = local.region

  assume_role {
    role_arn = "arn:aws:iam::${local.backup_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "backup_secondary_region"
  region = local.secondary_region

  assume_role {
    role_arn = "arn:aws:iam::${local.backup_account_id}:role/OrganizationAccountAccessRole"
  }
}
