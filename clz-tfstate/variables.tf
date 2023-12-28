variable "primary_region" {
  description = "The primary region where the resources will be deployed"
  type        = string
}

variable "tags" {
  description = "The tags to apply to all resources in this module"
  type        = map(string)
}
