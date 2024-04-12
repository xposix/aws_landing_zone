locals {
  tf_state_s3_bucket_name = "clz-terraform-state-${data.aws_caller_identity.primary_account.account_id}"
}
