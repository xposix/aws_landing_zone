# AWS Provider Configuration
provider "aws" {
  region = local.region

  assume_role {
    role_arn = local.assume_role_arn
  }
}

# AWS Master Provider Configuration
provider "aws" {
  alias  = "master"
  region = local.region
}
