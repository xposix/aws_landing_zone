variable "primary_region" {
  description = "The primary region where the resources will be deployed"
  type        = string
}

variable "secondary_region" {
  description = "The secondary region where the resources or backups will be deployed /saved"
  type        = string
}

variable "tags" {
  description = "The tags to apply to all resources in this module"
  type        = map(string)
}
