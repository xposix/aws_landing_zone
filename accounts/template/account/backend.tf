terraform {
  backend "s3" {
    region         = "{PRIMARY_REGION}"
    key            = "github.com/xposix/aws_landing_zone/{ACCOUNT_DIR}/{ACCOUNT_NAME}/terraform.tfstate"
    dynamodb_table = "terraform_locks_landing_zone_aws"
    encrypt        = true
  }
}
