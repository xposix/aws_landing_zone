locals {
  azs_count2 = [
    "${var.region}a",
    "${var.region}b",
  ]
  azs_count3 = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]

  public_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 3, 0),
    cidrsubnet(var.vpc_cidr, 3, 1),
  ]
  database_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 3, 2),
    cidrsubnet(var.vpc_cidr, 3, 3),
  ]
  private_subnets_count2 = [
    cidrsubnet(var.vpc_cidr, 2, 2),
    cidrsubnet(var.vpc_cidr, 2, 3),
  ]
  public_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 4, 0),
    cidrsubnet(var.vpc_cidr, 4, 1),
    cidrsubnet(var.vpc_cidr, 4, 2),
  ]
  database_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 4, 4),
    cidrsubnet(var.vpc_cidr, 4, 5),
    cidrsubnet(var.vpc_cidr, 4, 6),
  ]
  private_subnets_count3 = [
    cidrsubnet(var.vpc_cidr, 3, 4),
    cidrsubnet(var.vpc_cidr, 3, 5),
    cidrsubnet(var.vpc_cidr, 3, 6),
  ]
  vpc_name                                              = var.vpc_name
  number_of_route_tables_per_private_and_db_subnet_type = var.single_nat_gateway ? 1 : var.n_of_AZs

  peer_region = var.peer_to_region == "" ? var.region : var.peer_to_region
}

resource "aws_security_group" "private_endpoints_sg" {
  name        = "vpce-${var.vpc_name}"
  description = "Allow TLS inbound traffic to Private Links"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    "Name" : "vpce-${var.vpc_name}"
    },
    var.project_tags
  )
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = var.vpc_name
  cidr = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_ipv6          = false

  create_database_subnet_route_table = true

  manage_default_security_group = false
  manage_default_route_table    = false
  manage_default_network_acl    = false

  single_nat_gateway = var.single_nat_gateway

  azs              = var.n_of_AZs == 3 ? local.azs_count3 : local.azs_count2
  private_subnets  = var.n_of_AZs == 3 ? local.private_subnets_count3 : local.private_subnets_count2
  public_subnets   = var.n_of_AZs == 3 ? local.public_subnets_count3 : local.public_subnets_count2
  database_subnets = var.n_of_AZs == 3 ? local.database_subnets_count3 : local.database_subnets_count2

  tags                = var.project_tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.private_endpoints_sg.id]

  endpoints = merge(
    contains(var.private_endpoints_to_enable, "s3") ? {
      s3 = {
        service         = "s3"
        service_type    = "Gateway"
        route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.database_route_table_ids])
        tags            = { Name = "s3-vpc-endpoint" }
      }
    } : {},
    contains(var.private_endpoints_to_enable, "dynamodb") ? {
      dynamodb = {
        service         = "dynamodb"
        service_type    = "Gateway"
        route_table_ids = module.vpc.private_route_table_ids
        tags            = { Name = "dynamodb-vpc-endpoint" }
      }
    } : {},
    { for endpoint in setsubtract(var.private_endpoints_to_enable, ["s3", "dynamodb"]) : endpoint => {
      service             = endpoint
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      }
    }
  )

  tags = var.project_tags
}

resource "aws_vpc_peering_connection" "new_vpc_to_hub" {
  count         = local.is_spoke ? 1 : 0
  peer_owner_id = var.owner_of_vpc_to_peer_to
  peer_vpc_id   = var.vpc_id_to_peer_to
  peer_region   = local.peer_region
  vpc_id        = module.vpc.vpc_id
  auto_accept   = false

  tags = merge(
    {
      "Name" : "${var.vpc_name} (${local.peer_region}) => Shared Services (${var.region})",
      "Side" : "Initiator"
    },
    var.project_tags
  )
}

# default route out of the new_vpc VPC
resource "aws_route" "new_vpc_private_subnets_to_hub" {
  count                     = local.is_spoke ? local.number_of_route_tables_per_private_and_db_subnet_type : 0
  route_table_id            = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.hub_vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.new_vpc_to_hub[0].id
}

resource "aws_route" "new_vpc_database_subnets_to_hub" {
  count                     = local.is_spoke ? local.number_of_route_tables_per_private_and_db_subnet_type : 0
  route_table_id            = module.vpc.database_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.hub_vpc[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.new_vpc_to_hub[0].id
}

# Tries to find the VPC in Shared Services by the name
data "aws_vpc" "hub_vpc" {
  count    = local.is_spoke ? 1 : 0
  provider = aws.remote_account
  id       = var.vpc_id_to_peer_to
}

resource "aws_vpc_peering_connection_accepter" "hub_to_new_vpc" {
  count                     = local.is_spoke ? 1 : 0
  provider                  = aws.remote_account
  vpc_peering_connection_id = aws_vpc_peering_connection.new_vpc_to_hub[0].id
  auto_accept               = true

  tags = merge(
    {
      "Name" : "${var.vpc_name} (${local.peer_region}) => Shared Services (${var.region})",
      "Side" : "Accepter"
    },
    var.project_tags
  )
}

data "aws_route_tables" "remote_rtb_ids_if_single_nat_disabled_in_shared_services_live" {
  count    = local.is_spoke ? 1 : 0
  provider = aws.remote_account
  vpc_id   = var.vpc_id_to_peer_to

  filter {
    name   = "tag:Name"
    values = ["*-private-*"]
  }
}

data "aws_route_tables" "remote_rtb_ids_if_single_nat_enabled_in_shared_services_live" {
  count    = local.is_spoke ? 1 : 0
  provider = aws.remote_account
  vpc_id   = var.vpc_id_to_peer_to

  filter {
    name   = "tag:Name"
    values = ["*-private"]
  }
}

# Route out of the new_vpc VPC
resource "aws_route" "hub_to_new_vpc" {
  # for_each = local.is_spoke ? toset(data.aws_route_tables.remote_private_route_table_ids[0].ids) : {}

  for_each = local.is_spoke ? {
    for i in concat(data.aws_route_tables.remote_rtb_ids_if_single_nat_disabled_in_shared_services_live[0].ids, data.aws_route_tables.remote_rtb_ids_if_single_nat_enabled_in_shared_services_live[0].ids) :
    i => 0
  } : {}
  provider = aws.remote_account

  route_table_id = each.key

  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.hub_to_new_vpc[0].id
}
