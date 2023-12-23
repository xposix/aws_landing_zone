module "replicated_buckets" {
  source = "../replicated_s3_bucket"

  providers = {
    aws.management = aws.management
    aws.backup     = aws.backup
  }

  enable_replication = var.enable_replication

  bucket_name    = local.bucket_name
  primary_region = var.primary_region
  backup_region  = var.backup_region
  tags           = var.tags
  enable_kms     = var.enable_kms

}
