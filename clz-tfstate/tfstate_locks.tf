resource "aws_dynamodb_table" "terraform_locks_landing_zone_aws" {
  name           = "terraform_locks_landing_zone_aws"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge({
    "Name" : "terraform_locks_landing_zone_aws"
    },
  var.tags)

}
