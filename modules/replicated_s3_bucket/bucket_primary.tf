# AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "replication_origin" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = var.project_tags
}

resource "aws_s3_bucket_ownership_controls" "replication_origin" {
  bucket = aws_s3_bucket.replication_origin.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "replication_origin" {
  count  = var.enable_replication ? 1 : 0
  bucket = aws_s3_bucket.replication_origin.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "",
  "Statement": [
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.backup_account_id}:root"
      },
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ObjectOwnerOverrideToBucketOwner",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:GetObject",
        "s3:InitiateReplication"
      ],
      "Resource": "${aws_s3_bucket.replication_origin.arn}/*"
    },
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.backup_account_id}:root"
      },
      "Action": [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning",
        "s3:GetReplicationConfiguration",
        "s3:PutInventoryConfiguration"
      ],
      "Resource": "${aws_s3_bucket.replication_origin.arn}"
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.enable_replication ? 1 : 0
  depends_on = [
    aws_s3_bucket_versioning.replication_origin,
    aws_s3_bucket_versioning.replication_destination
  ]

  role   = aws_iam_role.replication[0].arn
  bucket = aws_s3_bucket.replication_origin.id

  rule {
    id     = "replication_destination"
    status = "Enabled"

    dynamic "source_selection_criteria" {
      for_each = var.enable_kms ? [1] : []
      content {
        sse_kms_encrypted_objects {
          status = "Enabled"
        }
      }
    }

    destination {
      bucket        = aws_s3_bucket.replication_destination[0].arn
      storage_class = "STANDARD_IA"
      dynamic "encryption_configuration" {
        for_each = var.enable_kms ? [1] : []
        content {
          replica_kms_key_id = aws_kms_key.replication_destination[0].arn
        }
      }
      account = local.backup_account_id
      access_control_translation {
        owner = "Destination"
      }
    }
  }
}

resource "aws_s3_bucket_versioning" "replication_origin" {
  bucket = aws_s3_bucket.replication_origin.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replication_origin" {
  count  = var.enable_kms ? 1 : 0
  bucket = aws_s3_bucket.replication_origin.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.replication_origin[0].arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "replication_origin" {
  bucket = aws_s3_bucket.replication_origin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
