locals {
  athena_bucket_name = "athena-default-results"
}

resource "aws_s3_bucket" "athena_bucket" {
  bucket        = local.athena_bucket_name
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 14
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.athena_bucket.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "athena_bucket" {
  description             = "This key is used to encrypt athena-default-results bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "athena_bucket" {
  name          = "alias/athena_bucket"
  target_key_id = aws_kms_key.athena_bucket.key_id
}
