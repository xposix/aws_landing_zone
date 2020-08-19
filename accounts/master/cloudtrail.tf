locals {
  cloudtrail_master_global_org_bucket = "cloudtrail-master-global-org"
}

resource "aws_cloudtrail" "cloudtrail_master_global_org" {
  name                          = "cloudtrail_master_global_org"
  s3_bucket_name                = local.cloudtrail_master_global_org_bucket
  s3_key_prefix                 = "v1"
  include_global_service_events = true
  is_organization_trail         = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cloudwatch_logs.arn
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail_master_global_org.arn

  kms_key_id = data.aws_kms_alias.cloudtrail_master_global_org.target_key_arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
}
  }
}

resource "aws_s3_bucket" "cloudtrail_master_global_org" {
  provider      = aws.audit
  bucket        = local.cloudtrail_master_global_org_bucket
  force_destroy = true

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
  provider = aws.audit
  bucket   = aws_s3_bucket.cloudtrail_master_global_org.id

  policy   = <<POLICY
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
              "${aws_s3_bucket.cloudtrail_master_global_org.arn}/v1/AWSLogs/${aws_organizations_organization.my_organisation.master_account_id}/*",
              "${aws_s3_bucket.cloudtrail_master_global_org.arn}/v1/AWSLogs/${aws_organizations_organization.my_organisation.id}/*"
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
  provider                = aws.audit
  description             = "This key is used to encrypt cloudtrail bucket objects"
  deletion_window_in_days = 30

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${aws_organizations_account.audit.id}:root"
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
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${aws_organizations_organization.my_organisation.master_account_id}:trail/*"
        }
      }
    },
    {
      "Sid": "Allow cloudwatch logs to use key",
      "Effect": "Allow",
      "Principal": { "Service": "logs.${local.region}.amazonaws.com" },
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
          "kms:CallerAccount": "${aws_organizations_organization.my_organisation.master_account_id}"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${aws_organizations_organization.my_organisation.master_account_id}:trail/*"
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
          "kms:ViaService": "ec2.${local.region}.amazonaws.com",
          "kms:CallerAccount": "${aws_organizations_organization.my_organisation.master_account_id}"
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
        "StringEquals": {"kms:CallerAccount": "${aws_organizations_organization.my_organisation.master_account_id}"},
        "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${aws_organizations_organization.my_organisation.master_account_id}:trail/*"}
      }
    }
  ]
}
POLICY
}

resource "aws_kms_alias" "cloudtrail_master_global_org" {
  provider      = aws.audit
  name          = "alias/cloudtrail_master_global_org"
  target_key_id = aws_kms_key.cloudtrail_master_global_org.key_id
}
