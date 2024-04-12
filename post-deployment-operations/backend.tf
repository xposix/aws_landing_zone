terraform {
  backend "s3" {
    region         = "eu-west-1"
    key            = "github.com/xposix/aws_landing_zone/post-deployment-operations/terraform.tfstate"
    dynamodb_table = "tfstate_locks_clz_accounts"
    encrypt        = true
  }
}
