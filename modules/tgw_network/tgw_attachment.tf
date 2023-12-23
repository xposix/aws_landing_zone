# new_vpc VPC attchment to the transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "new_vpc" {
  count              = local.enable_tgw_connectivity ? 1 : 0
  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = data.aws_ec2_transit_gateway.prod[0].id
  vpc_id             = module.vpc.vpc_id

  tags = merge(var.tags,
    {
      Name = var.tags.project_name
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "new_vpc" {
  count                         = local.enable_tgw_connectivity ? 1 : 0
  provider                      = aws.network
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.new_vpc[0].id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = true

  tags = merge(var.tags,
    {
      Name = var.tags.project_name
    }
  )
}
