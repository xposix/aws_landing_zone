resource "aws_ec2_transit_gateway" "prod" {
  description = "The production aws transit gateway for all VPCs within the company's cloud landing zone"

  amazon_side_asn = 64512

  auto_accept_shared_attachments = "disable"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name    = "transit_gateway_prod"
    env     = "production"
    account = "network"
  }
}

resource "aws_ram_principal_association" "transit_gateway_prod" {
  principal          = data.aws_organizations_organization.my_organisation.arn
  resource_share_arn = aws_ram_resource_share.transit_gateway_prod.arn
}

resource "aws_ram_resource_association" "transit_gateway_prod" {
  resource_arn       = aws_ec2_transit_gateway.prod.arn
  resource_share_arn = aws_ram_resource_share.transit_gateway_prod.arn
}

resource "aws_ram_resource_share" "transit_gateway_prod" {
  name                      = "transit_gateway_prod"
  allow_external_principals = false

  tags = {
    Name    = "transit_gateway_prod"
    env     = "production"
    account = "network"
  }
}
