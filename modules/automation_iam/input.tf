data "aws_caller_identity" "current" {}

variable "max_session_duration" {
  description = "The max_session_duration of the IAM role"
  default     = 43200 # 12h
}

variable "lock_cicd_role_to_these_arns" {
  description = "Roles that are allowed to assume this the clz_aws_cicd_access role"
  type        = list(string)
  ## TODO You should add the role your CI/CD Engine 
  #       (Jenkins, DroneiO, etc) assumes in your Shared Services account
  # default     = ["arn:aws:iam::XXXXXXXXXXXXXX:role/clz_deployer_role"]
}
