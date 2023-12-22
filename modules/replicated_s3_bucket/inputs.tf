variable "bucket_name" {
  description = "Name of the bucket in primary account"
  type        = string
}

variable "enable_replication" {
  description = "Enable replication right now, this is useful to deploy the S3 bucket now and enable replication later"
  type        = bool
  default     = true
}

variable "enable_kms" {
  description = "Use dedicated KMS for encrypting those buckets or just AES256 encryption"
  type        = bool
  default     = false
}

variable "primary_region" {
  description = "Region of the original bucket"
  type        = string
}

variable "backup_region" {
  description = "Region to create the replication bucket"
  type        = string
}

variable "project_tags" {
  type        = map(any)
  description = "A key/value map containing tags to add to all resources"
  # EXAMPLE
  # default = {
  #   Name        = "replication_origin"
  #   repo        = "github.com/xposix/aws_landing_zone/replication_origin"
  #   environment = "production"
  # }
}

data "aws_organizations_organization" "my_organisation" { provider = aws.master }
data "aws_caller_identity" "current" {}

locals {
  primary_account_id = data.aws_caller_identity.current.account_id

  backup_account_id = var.enable_replication ? [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == "backup"
  ].0 : ""
}
