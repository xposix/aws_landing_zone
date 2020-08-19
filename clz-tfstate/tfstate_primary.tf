# AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "terraform_state_landing_zone_aws" {
  bucket        = "terraform-state-landing-zone-aws"
  acl           = "private"
  force_destroy = false

  tags = var.tags

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "terraform_state_landing_zone_aws_backup"
      prefix = ""
      status = "Enabled"

      destination {
        bucket             = aws_s3_bucket.terraform_state_landing_zone_aws_backup.arn
        replica_kms_key_id = aws_kms_key.terraform_state_landing_zone_aws_backup.arn
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "true"
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
        kms_master_key_id = aws_kms_key.terraform_state_landing_zone_aws.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "terraform_state_landing_zone_aws" {
  description             = "This key is used to encrypt clear landing zone terraform state bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform_state_landing_zone_aws" {
  name          = "alias/terraform_state_landing_zone_aws"
  target_key_id = aws_kms_key.terraform_state_landing_zone_aws.key_id
}
