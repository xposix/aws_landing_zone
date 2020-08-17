locals {
  azs_count2 = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b",
  ]
  azs_count3 = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b",
    "${data.aws_region.current.name}c",
  ]
  private_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 2, 0),
    cidrsubnet(var.vpc_cidr, 2, 1),
  ]
  private_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 3, 0),
    cidrsubnet(var.vpc_cidr, 3, 1),
    cidrsubnet(var.vpc_cidr, 3, 2),
  ]
  public_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 3, 4),
    cidrsubnet(var.vpc_cidr, 3, 5),
  ]
  public_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 3, 3),
    cidrsubnet(var.vpc_cidr, 3, 4),
    cidrsubnet(var.vpc_cidr, 3, 5),
  ]
  database_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 3, 6),
    cidrsubnet(var.vpc_cidr, 3, 7),
  ]
  database_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 4, 12),
    cidrsubnet(var.vpc_cidr, 4, 13),
    cidrsubnet(var.vpc_cidr, 4, 14),
  ]
}

module "vpc" {
  source     = "terraform-aws-modules/vpc/aws"
  version    = "2.33.0"
  create_vpc = true

  name = "${var.project_tags.project_name}-${var.vpc_name}"
  cidr = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = local.enable_local_nats
  enable_vpn_gateway   = false
  enable_ipv6          = false

  enable_s3_endpoint = true

  create_database_subnet_route_table = true

  azs              = var.n_of_AZs == 3 ? local.azs_count3 : local.azs_count2
  private_subnets  = var.n_of_AZs == 3 ? local.private_subnets_count3 : local.private_subnets_count2
  public_subnets   = var.n_of_AZs == 3 ? local.public_subnets_count3 : local.public_subnets_count2
  database_subnets = var.n_of_AZs == 3 ? local.database_subnets_count3 : local.database_subnets_count2

  tags                = var.project_tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

# default route out of the new_vpc VPC
resource "aws_route" "new_vpc_to_tgw" {
  count                  = local.enable_tgw_connectivity ? length(module.vpc.azs) : 0
  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.prod[0].id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.new_vpc,
  ]
}
