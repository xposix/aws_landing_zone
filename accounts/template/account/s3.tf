module "terraform-project-state-buckets" {
  source             = "../../modules/tfstate_s3_bucket"
  primary_region     = var.primary_region
  backup_region      = var.secondary_region
  local_account_name = local.account_name
  project_tags       = local.project_tags
}
