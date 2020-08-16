# AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "terraform_state_local_projects" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = false
  region        = var.primary_region

  tags = var.project_tags

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "terraform_state_local_projects_backup"
      prefix = ""
      status = "Enabled"

      destination {
        bucket             = aws_s3_bucket.terraform_state_local_projects_backup.arn
        replica_kms_key_id = aws_kms_key.terraform_state_local_projects_backup.arn
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
        kms_master_key_id = aws_kms_key.terraform_state_local_projects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_kms_key" "terraform_state_local_projects" {
  description             = "This key is used to encrypt project's terraform state bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "terraform_state_local_projects" {
  name          = "alias/terraform_state_local_projects"
  target_key_id = aws_kms_key.terraform_state_local_projects.key_id
}
