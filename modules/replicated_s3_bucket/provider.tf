# AWS backup Provider Configuration
provider "aws" {
  alias  = "backup"
}

# AWS Master Provider Configuration
provider "aws" {
  alias  = "master"
}
