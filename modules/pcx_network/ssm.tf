resource "aws_ssm_parameter" "vpc-id" {
  name  = "/clz/vpc/${var.vpc_name}/id"
  type  = "String"
  value = module.vpc.vpc_id

  tags = var.project_tags
}

resource "aws_ssm_parameter" "vpc-private-subnets-id" {
  name  = "/clz/vpc/${var.vpc_name}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)

  tags = var.project_tags
}

resource "aws_ssm_parameter" "vpc-db-subnets-id" {
  name  = "/clz/vpc/${var.vpc_name}/db_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnets)

  tags = var.project_tags
}

resource "aws_ssm_parameter" "vpc-n-of-azs" {
  name  = "/clz/vpc/${var.vpc_name}/n_of_azs"
  type  = "String"
  value = var.n_of_AZs

  tags = var.project_tags
}

resource "aws_ssm_parameter" "vpc-private-endpoints-sg-id" {
  name  = "/clz/vpc/${var.vpc_name}/private_endpoint_sg_id"
  type  = "String"
  value = aws_security_group.private_endpoints_sg.id

  tags = var.project_tags
}
