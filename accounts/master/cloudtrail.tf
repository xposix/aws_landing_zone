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
}

data "aws_kms_alias" "cloudtrail_master_global_org" {
  provider = aws.audit
  name     = "alias/cloudtrail_master_global_org"
}
