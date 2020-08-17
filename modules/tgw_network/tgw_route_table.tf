# new_vpc vpc transit gateway route table
resource "aws_ec2_transit_gateway_route_table" "new_vpc" {
  count              = local.enable_tgw_connectivity ? 1 : 0
  provider           = aws.network
  transit_gateway_id = data.aws_ec2_transit_gateway.prod[0].id

  tags = merge(var.project_tags,
    {
      Name = var.project_tags.project_name
    }
  )
}

# new_vpc vpc transit gateway route table association
resource "aws_ec2_transit_gateway_route_table_association" "new_vpc" {
  count                          = local.enable_tgw_connectivity ? 1 : 0
  provider                       = aws.network
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment_accepter.new_vpc[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.new_vpc[0].id
}

# gateway_prod default internet route
data "aws_ec2_transit_gateway_vpc_attachment" "gateway_prod" {
  count    = local.enable_tgw_connectivity ? 1 : 0
  provider = aws.network
  filter {
    name   = "tag:Name"
    values = ["gateway_prod"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_ec2_transit_gateway_route" "new_vpc_default_nat_gateway" {
  count                          = local.enable_tgw_connectivity ? 1 : 0
  provider                       = aws.network
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.gateway_prod[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.new_vpc[0].id
}

# shared_services_prod route
data "aws_ec2_transit_gateway_vpc_attachment" "shared_services_prod" {
  count    = local.enable_tgw_connectivity ? 1 : 0
  provider = aws.network
  filter {
    name   = "tag:Name"
    values = ["shared_services_live"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_ec2_transit_gateway_route_table_propagation" "new_vpc_to_shared_services_prod" {
  count                          = local.enable_tgw_connectivity ? 1 : 0
  provider                       = aws.network
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.shared_services_prod[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.new_vpc[0].id
}
