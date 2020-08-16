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

variable "project_tags" {
  type        = map
  description = "A key/value map containing tags to add to all resources"
  # EXAMPLE
  # default = {
  #   Name        = "terraform_state_local_projects"
  #   repo        = "github.com/xposix/aws_landing_zone/local_projects"
  #   environment = "production"
  # }
}

locals {
  primary_account_id = [
    for a in data.aws_organizations_organization.my_organisation.accounts :
    a["id"]
    if a["name"] == var.local_account_name
  ].0
  backup_account_id = "TO_FILL"
  bucket_name       = "terraform-state-local-projects-${replace(var.local_account_name, "_", "-")}"
}
