variable "roles" {
  description = "A list of the roles that should be deployed by this module"
  type        = list
  default     = []
}

variable "enable_saml_provider" {
  description = "if true deploys the aws_iam_saml_provider into the account"
  default     = true
}

variable "saml_provider_arn" {
  description = "if enable_saml_provider false then you can specify an external provider arn"
  default     = ""
}

variable "provider_name" {
  description = "Name of the SAML identity provider"
  default     = "gsuite"
}

variable "saml_metadata_document_path" {
  description = "The contents of the saml metadata document"
  default     = ""
}

variable "google_oauth_client_id" {
  description = "The google client id passed from the aws-credentials-broker"
}

variable "master_account_id" {
  description = "The account number of master/organisations root"
  default     = ""
}

variable "max_session_duration" {
  description = "The max_session_duration of the IAM role"
  default     = 43200 # 12h
}

variable "assume_by_arns" {
  description = "Roles that are allowed to assume this api_access roles"
  type        = list(string)
  default     = []
}

variable "aws_organizations_accounts" {
  description = "accounts provided by data.aws_organizations_organization"
}
