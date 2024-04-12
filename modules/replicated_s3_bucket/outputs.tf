
output "source_bucket_arn" {
  description = "ARN of the new bucket"
  value       = aws_s3_bucket.replication_origin.arn
}

output "replication_bucket_arn" {
  description = "ARN of the bucket containing the replicated files"
  value       = var.enable_replication ? aws_s3_bucket.replication_destination[0].arn : ""
}

output "source_bucket_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the files in the source bucket."
  value       = var.enable_kms ? aws_kms_key.replication_origin[0].arn : ""
}

output "replication_bucket_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the files in the destination bucket."
  value       = var.enable_kms ? aws_kms_key.replication_destination[0].arn : ""
}
