terraform {
  backend "s3" {
    # TO_FILL
    region         = "eu-west-1"
    bucket         = "{COMPANY_PREFIX}-terraform-state-landing-zone-aws"
    key            = "github.com/xposix/aws_landing_zone/accounts/master/terraform.tfstate"
    dynamodb_table = "terraform_locks_landing_zone_aws"
    encrypt        = true
  }
}
