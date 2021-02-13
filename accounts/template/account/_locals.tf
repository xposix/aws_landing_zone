locals {
  account_name       = "{ACCOUNT_NAME}"
  company_dns_domain = "{COMPANY_ROUTE53_DOMAIN}"
  dns_subdomain      = "{DNS_SUBDOMAIN}"

  project_tags = {
    project_name = local.account_name
    repo         = "github.com/xposix/aws_landing_zone"
    Terraform    = "true"
    environment  = "{ENVIRONMENT_TYPE}"
  }

  iam_roles_to_deploy = [
    # "clz_aws_admin_access",
    # "clz_aws_power_user_access",
    # "clz_aws_readonly_access"
  ]

  account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == local.account_name
  ].0

  assume_role_arn = "arn:aws:iam::${local.account_id}:role/{ORGANISATIONS_DEPLOYER_ROLE}"
}

locals {
  primary-region-vpc1 = {
    vpc_name = "vpc1"
    n_of_AZs = "{NUMBER_OF_AZS}"
    vpc_cidr = "{VPC_CIDR}"
  }
}

variable "region" {
  default = "{PRIMARY_REGION}"
}

variable "secondary_region" {
  default = "{SECONDARY_REGION}"
}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
