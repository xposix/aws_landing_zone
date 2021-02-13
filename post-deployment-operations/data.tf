data "aws_organizations_organization" "my_organisation" {}

data "terraform_remote_state" "shared_services" {
  backend = "s3"
  config = {
    region = "eu-west-1"
    bucket = "{COMPANY_PREFIX}-tfstate-clz-accounts-master"
    key    = "github.com/xposix/aws_landing_zone/accounts/shared_services_live/terraform.tfstate"
  }
}
