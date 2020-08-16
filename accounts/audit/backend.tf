terraform {
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "terraform-state-landing-zone-aws"
    key            = "github.com/xposix/aws_landing_zone/accounts/audit/terraform.tfstate"
    dynamodb_table = "terraform_locks_landing_zone_aws"
    encrypt        = true
  }
}
