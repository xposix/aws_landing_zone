## Adding the automation roles at the end of the process
module "automation_iam_shared_services_live" {
  source = "../modules/automation_iam"

  lock_cicd_role_to_these_arns = [
    data.terraform_remote_state.shared_services.outputs.workers_role_arn
  ]

  providers = {
    aws = aws.shared_services_live
  }
}

module "automation_iam_shared_services_non_live" {
  source = "../modules/automation_iam"

  lock_cicd_role_to_these_arns = [
    data.terraform_remote_state.shared_services.outputs.workers_role_arn
  ]

  providers = {
    aws = aws.shared_services_non_live
  }
}

module "automation_iam_sandbox" {
  source = "../modules/automation_iam"

  lock_cicd_role_to_these_arns = [
    data.terraform_remote_state.shared_services.outputs.workers_role_arn
  ]

  providers = {
    aws = aws.sandbox
  }
}
