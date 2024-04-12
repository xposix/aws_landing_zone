terraform {
  backend "s3" {
    region         = "eu-west-1"
    key            = "github.com/xposix/aws_landing_zone/accounts/shared_services_live/terraform.tfstate"
    dynamodb_table = "terraform_locks_landing_zone_aws"
    encrypt        = true
  }
}
