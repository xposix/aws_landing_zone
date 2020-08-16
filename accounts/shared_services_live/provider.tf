# AWS Provider Configuration
provider "aws" {
  region = var.region

  assume_role {
    role_arn = local.assume_role_arn
  }
}

# AWS network Provider Configuration
provider "aws" {
  alias  = "network"
  region = var.region

  assume_role {
    role_arn = local.network_assume_role_arn
  }
}

# AWS Master Provider Configuration
provider "aws" {
  alias  = "master"
  region = var.region
}