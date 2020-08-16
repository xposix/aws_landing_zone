output "transit_gateway_prod_id" {
  value = aws_ec2_transit_gateway.prod.id
}

output "tgw_vpc_attachments" {
  value = {
    gateway_prod = aws_ec2_transit_gateway_vpc_attachment.gateway_prod.id
  }
}
