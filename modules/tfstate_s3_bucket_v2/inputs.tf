variable "primary_region" {
  description = "Region of the original bucket"
  type        = string
}

variable "backup_region" {
  description = "Region to create the replication bucket"
  type        = string
}

variable "local_account_name" {
  description = "Name of account origin, it's used to generate the name of the buckets and account ID lookup"
  type        = string
}

variable "bucket_purpose" {
  description = "What is this bucket for. Only alphanumeric and dashes. E.g.: local-projects"
  type        = string
  default     = "local-projects"
}

variable "project_tags" {
  type        = map(any)
  description = "A key/value map containing tags to add to all resources"
  # EXAMPLE
  # default = {
  #   Name        = "terraform_state_local_projects"
  #   repo        = "github.com/xposix/aws_landing_zone/local_projects"
  #   environment = "production"
  # }
}

variable "enable_kms" {
  description = "Use dedicated KMS for encrypting those buckets or just AES256 encryption"
  type        = bool
  default     = false
}

locals {
  bucket_name = "{COMPANY_PREFIX}-tfstate-${var.bucket_purpose}-${replace(var.local_account_name, "_", "-")}"
}
