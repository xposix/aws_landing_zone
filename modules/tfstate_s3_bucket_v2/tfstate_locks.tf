resource "aws_dynamodb_table" "terraform_locks_local_projects" {
  name         = "tfstate_locks_${replace(var.bucket_purpose, "-", "_")}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.project_tags
}
