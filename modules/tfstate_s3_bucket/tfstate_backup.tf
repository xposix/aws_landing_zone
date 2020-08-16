# BACKUP AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "terraform_state_local_projects_backup" {
  provider      = aws.backup
  bucket        = "${local.bucket_name}-backup"
  acl           = "private"
  force_destroy = false
  region        = var.backup_region

  tags = var.project_tags

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_state_local_projects_backup.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state_local_projects_backup" {
  provider = aws.backup
  bucket   = aws_s3_bucket.terraform_state_local_projects_backup.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "",
  "Statement": [
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.primary_account_id}:root"
      },
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Resource": [
        "${aws_s3_bucket.terraform_state_local_projects_backup.arn}/*"
      ]
    },
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.primary_account_id}:root"
      },
      "Action": [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.terraform_state_local_projects_backup.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_kms_key" "terraform_state_local_projects_backup" {
  provider                = aws.backup
  description             = "This key is used to encrypt project's terraform state bucket objects"
  deletion_window_in_days = 10

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${local.backup_account_id}:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Enable cross account encrypt access for S3 Cross Region Replication",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${local.primary_account_id}:root"
        },
        "Action": "kms:Encrypt",
        "Resource": "*"
      }
    ]
  }
  POLICY
}

resource "aws_kms_alias" "terraform_state_local_projects_backup" {
  provider      = aws.backup
  name          = "alias/terraform_state_${var.local_account_name}_local_projects_backup"
  target_key_id = aws_kms_key.terraform_state_local_projects_backup.key_id
}
