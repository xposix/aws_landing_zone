resource "aws_s3_bucket" "cloudtrail_master_global_org" {
  bucket        = "cloudtrail-master-global-org"
  force_destroy = true
  region        = var.region

  lifecycle_rule {
    enabled = true

    expiration {
      days = 180
    }
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.cloudtrail_master_global_org.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

resource "aws_s3_bucket_policy" "cloudtrail_master_global_org" {
  bucket = aws_s3_bucket.cloudtrail_master_global_org.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail_master_global_org.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
              "${aws_s3_bucket.cloudtrail_master_global_org.arn}/v1/AWSLogs/${data.aws_organizations_organization.my_organisation.master_account_id}/*",
              "${aws_s3_bucket.cloudtrail_master_global_org.arn}/v1/AWSLogs/${data.aws_organizations_organization.my_organisation.id}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_kms_key" "cloudtrail_master_global_org" {
  description             = "This key is used to encrypt cloudtrail bucket objects"
  deletion_window_in_days = 10

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow CloudTrail to encrypt logs",
      "Effect": "Allow",
      "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
      "Action": "kms:GenerateDataKey*",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_organizations_organization.my_organisation.master_account_id}:trail/*"
        }
      }
    },
    {
      "Sid": "Allow cloudwatch logs to use key",
      "Effect": "Allow",
      "Principal": { "Service": "logs.${var.region}.amazonaws.com" },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow CloudTrail to describe key",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com"
        ]
      },
      "Action": "kms:DescribeKey",
      "Resource": "*"
    },
    {
      "Sid": "Allow principals in the account to decrypt log files",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_organizations_organization.my_organisation.master_account_id}"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_organizations_organization.my_organisation.master_account_id}:trail/*"
        }
      }
    },
    {
    "Sid": "Allow alias creation during setup",
    "Effect": "Allow",
    "Principal": {
      "AWS": "*"
    },
    "Action": "kms:CreateAlias",
    "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": "ec2.${var.region}.amazonaws.com",
          "kms:CallerAccount": "${data.aws_organizations_organization.my_organisation.master_account_id}"
        }
      }
    },
    {
    "Sid": "Enable cross account log decryption",
    "Effect": "Allow",
    "Principal": {"AWS": "*"},
    "Action": [
    "kms:Decrypt",
    "kms:ReEncryptFrom"
    ],
    "Resource": "*",
      "Condition": {
        "StringEquals": {"kms:CallerAccount": "${data.aws_organizations_organization.my_organisation.master_account_id}"},
        "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${data.aws_organizations_organization.my_organisation.master_account_id}:trail/*"}
      }
    }
  ]
}
POLICY
}

resource "aws_kms_alias" "cloudtrail_master_global_org" {
  name          = "alias/cloudtrail_master_global_org"
  target_key_id = aws_kms_key.cloudtrail_master_global_org.key_id
}
