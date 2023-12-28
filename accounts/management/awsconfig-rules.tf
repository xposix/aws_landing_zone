locals {
  awsconfig_excluded_accounts = []
}

resource "aws_config_organization_managed_rule" "iam_password_policy" {
  name            = "iam_password_policy"
  rule_identifier = "IAM_PASSWORD_POLICY"

  input_parameters = <<EOF
{
  "RequireUppercaseCharacters" : "true",
  "RequireLowercaseCharacters" : "true",
  "RequireSymbols" : "true",
  "RequireNumbers" : "true",
  "MinimumPasswordLength" : "16"
}
EOF

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}


resource "aws_config_organization_managed_rule" "encrypted_volumes" {
  name            = "encrypted_volumes"
  rule_identifier = "ENCRYPTED_VOLUMES"

  resource_types_scope = ["AWS::EC2::Volume"]

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "ec2_instance_no_public_ip" {
  name            = "ec2_instance_no_public_ip"
  rule_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "incoming_ssh_disabled" {
  name            = "incoming_ssh_disabled"
  rule_identifier = "INCOMING_SSH_DISABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "cloud_trail_encryption_enabled" {
  name            = "cloud_trail_encryption_enabled"
  rule_identifier = "CLOUD_TRAIL_ENCRYPTION_ENABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "cloud_trail_log_file_validation_enabled" {
  name            = "cloud_trail_log_file_validation_enabled"
  rule_identifier = "CLOUD_TRAIL_LOG_FILE_VALIDATION_ENABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "cloudtrail_s3_dataevents_enabled" {
  name            = "cloudtrail_s3_dataevents_enabled"
  rule_identifier = "CLOUDTRAIL_S3_DATAEVENTS_ENABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "cloud_trail_enabled" {
  name            = "cloud_trail_enabled"
  rule_identifier = "CLOUD_TRAIL_ENABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  input_parameters = <<EOF
{
  "s3BucketName" : "${local.cloudtrail_management_global_org_bucket}"
}
EOF
  # "snsTopicArn" : ""
  # "cloudWatchLogsLogGroupArn" : "",

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "internet_gateway_authorized_vpc_only" {
  name            = "internet_gateway_authorized_vpc_only"
  rule_identifier = "INTERNET_GATEWAY_AUTHORIZED_VPC_ONLY"

  excluded_accounts = local.awsconfig_excluded_accounts

  #   input_parameters = <<EOF
  # {
  #   "authorizedVpcIds" : ""
  # }
  # EOF

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "vpc_vpn_2_tunnels_up" {
  name            = "vpc_vpn_2_tunnels_up"
  rule_identifier = "VPC_VPN_2_TUNNELS_UP"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "iam_policy_no_statements_with_admin_access" {
  name            = "iam_policy_no_statements_with_admin_access"
  rule_identifier = "IAM_POLICY_NO_STATEMENTS_WITH_ADMIN_ACCESS"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "mfa_enabled_for_iam_console_access" {
  name            = "mfa_enabled_for_iam_console_access"
  rule_identifier = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "root_account_hardware_mfa_enabled" {
  name            = "root_account_hardware_mfa_enabled"
  rule_identifier = "ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "efs_encrypted_check" {
  name            = "efs_encrypted_check"
  rule_identifier = "EFS_ENCRYPTED_CHECK"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}

resource "aws_config_organization_managed_rule" "s3_account_level_public_access_blocks" {
  name            = "s3_account_level_public_access_blocks"
  rule_identifier = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"

  excluded_accounts = local.awsconfig_excluded_accounts

  depends_on = [module.awsconfig]
}
