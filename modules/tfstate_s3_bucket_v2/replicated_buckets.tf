module "replicated_buckets" {
  source = "../replicated_s3_bucket"

  providers = {
    aws.master = aws.master
    aws.backup = aws.backup
  }

  bucket_name    = local.bucket_name
  primary_region = var.primary_region
  backup_region  = var.backup_region
  project_tags   = var.project_tags
  enable_kms     = var.enable_kms

}
