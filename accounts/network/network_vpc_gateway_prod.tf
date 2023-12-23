module "gateway_prod" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.25.0"

  name = "gateway_prod"
  cidr = local.gateway_prod_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_ipv6          = false

  azs = [
    "${var.primary_region}a",
    "${var.primary_region}b",
    "${var.primary_region}c"
  ]

  private_subnets = [
    cidrsubnet(local.gateway_prod_cidr, 3, 0),
    cidrsubnet(local.gateway_prod_cidr, 3, 1),
    cidrsubnet(local.gateway_prod_cidr, 3, 2),
  ]

  public_subnets = [
    cidrsubnet(local.gateway_prod_cidr, 3, 3),
    cidrsubnet(local.gateway_prod_cidr, 3, 4),
    cidrsubnet(local.gateway_prod_cidr, 3, 5),
  ]

  tags = var.tags

}

resource "aws_route" "gateway_prod_public_subnets_to_aws" {
  count                  = length(module.gateway_prod.public_route_table_ids)
  route_table_id         = module.gateway_prod.public_route_table_ids[count.index]
  destination_cidr_block = local.aws_cidr_range # All of AWS
  transit_gateway_id     = aws_ec2_transit_gateway.prod.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.gateway_prod,
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "gateway_prod" {
  subnet_ids         = module.gateway_prod.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.prod.id
  vpc_id             = module.gateway_prod.vpc_id

  tags = var.tags

}

resource "aws_ec2_transit_gateway_route" "default_nat_gateway" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.gateway_prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.prod.association_default_route_table_id
}
