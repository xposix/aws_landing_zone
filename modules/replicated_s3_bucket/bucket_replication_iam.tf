resource "aws_iam_role" "replication" {
  count       = var.enable_replication ? 1 : 0
  name_prefix = "${substr(var.bucket_name, 0, 20)}-replication"
  description = "Allow S3 to assume the role for replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3ReplicationAssume",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  count       = var.enable_replication ? 1 : 0
  name_prefix = "${var.bucket_name}-replicationpolicy"
  description = "Allows reading for replication."

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.replication_origin.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.replication_origin.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ObjectOwnerOverrideToBucketOwner",
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replication_destination[0].arn}/*"
    }
    %{if var.enable_kms}
    ,{
      "Action": "kms:Decrypt",
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${var.primary_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.replication_origin.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.replication_origin[0].arn}"
      ]
    },
    {
      "Action": "kms:Encrypt",
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${var.backup_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.replication_destination[0].arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.replication_destination[0].arn}"
      ]
    }
    %{endif}
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  count      = var.enable_replication ? 1 : 0
  name       = "${var.bucket_name}_bucket_projects_aws_rep"
  roles      = [aws_iam_role.replication[0].name]
  policy_arn = aws_iam_policy.replication[0].arn
}
