# AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "replication_origin" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = false

  tags = var.project_tags

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "replication_destination"
      prefix = ""
      status = "Enabled"

      dynamic "source_selection_criteria" {
        for_each = var.enable_kms ? [1] : []
        content {
          sse_kms_encrypted_objects {
            enabled = "true"
          }
        }
      }

      destination {
        bucket             = aws_s3_bucket.replication_destination.arn
        storage_class      = "STANDARD_IA"
        replica_kms_key_id = var.enable_kms ? aws_kms_key.replication_destination[0].arn : ""
        account_id         = local.backup_account_id
        access_control_translation {
          owner = "Destination"
        }
      }
    }
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.enable_kms ? "aws:kms" : "AES256"
        kms_master_key_id = var.enable_kms ? aws_kms_key.replication_origin[0].arn : ""
      }
    }
  }
}

resource "aws_kms_key" "replication_origin" {
  count                   = var.enable_kms ? 1 : 0
  description             = "This key is used to encrypt ${var.bucket_name} bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "replication_origin" {
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${var.bucket_name}"
  target_key_id = aws_kms_key.replication_origin[0].key_id
}
