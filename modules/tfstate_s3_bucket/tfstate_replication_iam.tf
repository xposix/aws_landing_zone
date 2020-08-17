resource "aws_iam_role" "replication" {
  name_prefix = "tfstate_projects_aws_rep"
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
  name_prefix = "tfstate_projects_aws_rep"
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
        "${aws_s3_bucket.terraform_state_local_projects.arn}"
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
        "${aws_s3_bucket.terraform_state_local_projects.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ObjectOwnerOverrideToBucketOwner",
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.terraform_state_local_projects_backup.arn}/*"
    },
    {
      "Action": "kms:Decrypt",
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${var.primary_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.terraform_state_local_projects.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.terraform_state_local_projects.arn}"
      ]
    },
    {
      "Action": "kms:Encrypt",
      "Effect": "Allow",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${var.backup_region}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.terraform_state_local_projects_backup.arn}/*"
          ]
        }
      },
      "Resource": [
        "${aws_kms_key.terraform_state_local_projects_backup.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "tfstate_projects_aws_rep"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}
