resource "aws_dynamodb_table" "terraform_locks_local_projects" {
  name         = "terraform_locks_local_projects"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.project_tags
}
