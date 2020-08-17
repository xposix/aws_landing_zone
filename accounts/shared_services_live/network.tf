data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    # TO_FILL
    region = "eu-west-1"
    bucket = "terraform-state-landing-zone-aws"
    key    = "github.com/xposix/aws_landing_zone/accounts/network/terraform.tfstate"
  }
}
