# AWS Provider Configuration
provider "aws" {
  region = var.primary_region

  assume_role {
    role_arn = local.assume_role_arn
  }
}

# AWS Management Account Provider Configuration
provider "aws" {
  alias  = "management"
  region = var.primary_region
}
