# AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "terraform_state_landing_zone_aws" {
  bucket        = local.tf_state_s3_bucket_name
  force_destroy = false

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "terraform_state_landing_zone_aws" {
  bucket = aws_s3_bucket.terraform_state_landing_zone_aws.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_landing_zone_aws" {
  bucket = aws_s3_bucket.terraform_state_landing_zone_aws.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_landing_zone_aws" {
  bucket = aws_s3_bucket.terraform_state_landing_zone_aws.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
