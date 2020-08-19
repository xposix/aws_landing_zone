data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    # TO_FILL
    region = "eu-west-1"
    bucket = "{COMPANY_PREFIX}-terraform-state-landing-zone-aws"
    key    = "github.com/xposix/aws_landing_zone/accounts/network/terraform.tfstate"
  }
}

data "aws_ec2_transit_gateway" "prod" {
  id = data.terraform_remote_state.network.outputs.transit_gateway_prod_id
}
