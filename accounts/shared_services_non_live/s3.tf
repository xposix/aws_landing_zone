module "projects-backups-replication-buckets" {
  source = "../../modules/replicated_s3_bucket"
  providers = {
    aws.management = aws.management
    aws.backup     = aws.backup
  }
  bucket_name    = "{COMPANY_PREFIX}-local-projects-${replace(local.account_name, "_", "-")}"
  primary_region = var.primary_region
  backup_region  = var.secondary_region
  tags           = var.tags
  enable_kms     = false
}


module "terraform-project-state-buckets-v2" {
  source = "../../modules/tfstate_s3_bucket_v2"

  providers = {
    aws.management = aws.management
    aws.backup     = aws.backup
  }

  primary_region     = var.primary_region
  backup_region      = var.secondary_region
  tags               = var.tags
  local_account_name = local.account_name
  bucket_purpose     = "local-projects"
  enable_kms         = false

}
