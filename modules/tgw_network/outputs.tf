
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = module.vpc.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = module.vpc.vpc_enable_dns_hostnames
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = module.vpc.vpc_secondary_cidr_blocks
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.vpc.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.vpc.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.vpc.database_subnets_cidr_blocks
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.vpc.database_subnet_group
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = module.vpc.database_route_table_ids
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

# VPC Endpoints
output "vpc_endpoint_s3_id" {
  description = "The ID of VPC endpoint for S3"
  value       = module.vpc.vpc_endpoint_s3_id
}

output "vpc_endpoint_s3_pl_id" {
  description = "The prefix list for the S3 VPC endpoint."
  value       = module.vpc.vpc_endpoint_s3_pl_id
}

output "vpc_endpoint_dynamodb_id" {
  description = "The ID of VPC endpoint for DynamoDB"
  value       = module.vpc.vpc_endpoint_dynamodb_id
}

output "vpc_endpoint_dynamodb_pl_id" {
  description = "The prefix list for the DynamoDB VPC endpoint."
  value       = module.vpc.vpc_endpoint_dynamodb_pl_id
}

output "vpc_endpoint_sqs_id" {
  description = "The ID of VPC endpoint for SQS"
  value       = module.vpc.vpc_endpoint_sqs_id
}

output "vpc_endpoint_sqs_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SQS."
  value       = module.vpc.vpc_endpoint_sqs_network_interface_ids
}

output "vpc_endpoint_sqs_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SQS."
  value       = module.vpc.vpc_endpoint_sqs_dns_entry
}

output "vpc_endpoint_ssm_id" {
  description = "The ID of VPC endpoint for SSM"
  value       = module.vpc.vpc_endpoint_ssm_id
}

output "vpc_endpoint_ssm_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_network_interface_ids
}

output "vpc_endpoint_ssm_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSM."
  value       = module.vpc.vpc_endpoint_ssm_dns_entry
}

output "vpc_endpoint_ssmmessages_id" {
  description = "The ID of VPC endpoint for SSMMESSAGES"
  value       = module.vpc.vpc_endpoint_ssmmessages_id
}

output "vpc_endpoint_ssmmessages_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for SSMMESSAGES."
  value       = module.vpc.vpc_endpoint_ssmmessages_network_interface_ids
}

output "vpc_endpoint_ssmmessages_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for SSMMESSAGES."
  value       = module.vpc.vpc_endpoint_ssmmessages_dns_entry
}

output "vpc_endpoint_ec2_id" {
  description = "The ID of VPC endpoint for EC2"
  value       = module.vpc.vpc_endpoint_ec2_id
}

output "vpc_endpoint_ec2_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for EC2"
  value       = module.vpc.vpc_endpoint_ec2_network_interface_ids
}

output "vpc_endpoint_ec2_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for EC2."
  value       = module.vpc.vpc_endpoint_ec2_dns_entry
}

output "vpc_endpoint_ec2messages_id" {
  description = "The ID of VPC endpoint for EC2MESSAGES"
  value       = module.vpc.vpc_endpoint_ec2messages_id
}

output "vpc_endpoint_ec2messages_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for EC2MESSAGES"
  value       = module.vpc.vpc_endpoint_ec2messages_network_interface_ids
}

output "vpc_endpoint_ec2messages_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for EC2MESSAGES."
  value       = module.vpc.vpc_endpoint_ec2messages_dns_entry
}

output "vpc_endpoint_ecr_api_id" {
  description = "The ID of VPC endpoint for ECR API"
  value       = module.vpc.vpc_endpoint_ecr_api_id
}

output "vpc_endpoint_ecr_api_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECR API."
  value       = module.vpc.vpc_endpoint_ecr_api_network_interface_ids
}

output "vpc_endpoint_ecr_api_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECR API."
  value       = module.vpc.vpc_endpoint_ecr_api_dns_entry
}

output "vpc_endpoint_ecr_dkr_id" {
  description = "The ID of VPC endpoint for ECR DKR"
  value       = module.vpc.vpc_endpoint_ecr_dkr_id
}

output "vpc_endpoint_ecr_dkr_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for ECR DKR."
  value       = module.vpc.vpc_endpoint_ecr_dkr_network_interface_ids
}

output "vpc_endpoint_ecr_dkr_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for ECR DKR."
  value       = module.vpc.vpc_endpoint_ecr_dkr_dns_entry
}

output "vpc_endpoint_athena_id" {
  description = "The ID of VPC endpoint for Athena"
  value       = module.vpc.vpc_endpoint_athena_id
}

output "vpc_endpoint_athena_network_interface_ids" {
  description = "One or more network interfaces for the VPC Endpoint for Athena."
  value       = module.vpc.vpc_endpoint_athena_network_interface_ids
}

output "vpc_endpoint_athena_dns_entry" {
  description = "The DNS entries for the VPC Endpoint for Athena."
  value       = module.vpc.vpc_endpoint_athena_dns_entry
}

# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.n_of_AZs == 3 ? local.azs_count3 : local.azs_count2
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = "${var.tags.project_name}-vpc"
}
