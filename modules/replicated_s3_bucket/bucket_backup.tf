# BACKUP AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "replication_destination" {
  provider      = aws.backup
  bucket        = "${var.bucket_name}-backup"
  acl           = "private"
  force_destroy = false

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
        sse_algorithm     = var.enable_kms ? "aws:kms" : "AES256"
        kms_master_key_id = var.enable_kms ? aws_kms_key.replication_destination[0].arn : ""
      }
    }
  }
}

resource "aws_s3_bucket_policy" "replication_destination" {
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination.id

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
        "${aws_s3_bucket.replication_destination.arn}/*"
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
        "${aws_s3_bucket.replication_destination.arn}"
      ]
    }
  ]
}
POLICY
}


resource "aws_kms_key" "replication_destination" {
  provider                = aws.backup
  count                   = var.enable_kms ? 1 : 0
  description             = "This key is used to encrypt ${var.bucket_name} bucket objects"
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

resource "aws_kms_alias" "replication_destination" {
  provider      = aws.backup
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${var.bucket_name}_backup"
  target_key_id = aws_kms_key.replication_destination[0].key_id
}



