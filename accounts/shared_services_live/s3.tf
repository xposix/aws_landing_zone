module "terraform-project-state-buckets" {
  source = "../../modules/tfstate_s3_bucket"

  # TO_FILL
  primary_region     = local.region
  backup_region      = local.backup_region
  local_account_name = local.account_name
  project_tags       = local.project_tags
}
