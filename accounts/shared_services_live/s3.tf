module "terraform-project-state-buckets" {
  source = "../../modules/tfstate_s3_bucket"

  # TO_FILL
  primary_region     = "eu-west-1"
  backup_region      = "eu-west-2"
  local_account_name = local.account_name
  project_tags       = local.project_tags
}
