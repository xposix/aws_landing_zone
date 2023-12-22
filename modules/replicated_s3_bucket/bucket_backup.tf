# BACKUP AWS S3 Bucket for storing terraform state files
resource "aws_s3_bucket" "replication_destination" {
  count         = var.enable_replication ? 1 : 0
  provider      = aws.backup
  bucket        = "${var.bucket_name}-backup"
  force_destroy = false

  tags = var.project_tags

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replication_destination" {
  count    = var.enable_kms ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.replication_destination[0].arn
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "replication_destination" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination[0].id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "replication_destination" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "replication_destination" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "replication_destination" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.backup
  bucket   = aws_s3_bucket.replication_destination[0].id

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
        "${aws_s3_bucket.replication_destination[0].arn}/*"
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
        "${aws_s3_bucket.replication_destination[0].arn}"
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

  policy = data.aws_iam_policy_document.replication_destination.json
}

data "aws_iam_policy_document" "replication_destination" {
  statement {
    sid = "Enable IAM User Permissions"
    principals {
      type        = "AWS"
      identifiers = ["${local.backup_account_id}"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Enable cross account encrypt access for S3 Cross Region Replication"
    principals {
      type        = "AWS"
      identifiers = ["${local.primary_account_id}"]
    }

    actions = [
      "kms:Encrypt",
    ]

    resources = ["*"]
  }
}


resource "aws_kms_alias" "replication_destination" {
  provider      = aws.backup
  count         = var.enable_kms ? 1 : 0
  name          = "alias/${var.bucket_name}_backup"
  target_key_id = aws_kms_key.replication_destination[0].key_id
}



