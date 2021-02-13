resource "aws_s3_account_public_access_block" "s3_locks_for_backup_account" {
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
