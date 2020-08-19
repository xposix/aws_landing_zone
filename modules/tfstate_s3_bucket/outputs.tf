
output "source_bucket_arn" {
  description = "ARN of the new bucket"
  value       = aws_s3_bucket.terraform_state_local_projects.arn
}

output "replication_bucket_arn" {
  description = "ARN of the bucket containing the replicated files"
  value       = aws_s3_bucket.terraform_state_local_projects_backup.arn
}

output "source_bucket_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the files in the source bucket."
  value       = aws_kms_key.terraform_state_local_projects.arn
}

output "replication_bucket_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the files in the destination bucket."
  value       = aws_kms_key.terraform_state_local_projects_backup.arn
}

output "locks_dynamo_db" {
  description = "Dynamo DB ARN that contains all the Terraform locks for the projects in this account"
  value       = aws_dynamodb_table.terraform_locks_local_projects.arn
}
