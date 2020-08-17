data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    region = "eu-west-1"
    bucket = "terraform-state-landing-zone-aws"
    key    = "github.com/xposix/aws_landing_zone/accounts/network/terraform.tfstate"
  }
}

data "aws_ec2_transit_gateway" "prod" {
  count = local.enable_tgw_connectivity ? 1 : 0
  id    = data.terraform_remote_state.network.outputs.transit_gateway_prod_id
}

data "aws_region" "current" {}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
