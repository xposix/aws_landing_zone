locals {
  primary_region  = "eu-west-1"
  backup_region   = "eu-west-2"

  tags = {
    Name        = "terraform_state_landing_zone_aws"
    Repo        = "github.com/xposix/aws_landing_zone"
    Environment = "production"
  }
}
