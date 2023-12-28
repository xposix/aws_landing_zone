module "awsconfig" {
  source = "../../modules/awsconfig"
}

resource "aws_config_configuration_aggregator" "awsconfig_management_global_org" {
  depends_on = [
    module.awsconfig,
    aws_iam_role_policy_attachment.awsconfig_management_global_org,
  ]

  name = "awsconfig_management_global_org"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.awsconfig_management_global_org.arn
  }
}

resource "aws_iam_role" "awsconfig_management_global_org" {
  name = "awsconfig_management_global_org"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "awsconfig_management_global_org" {
  role       = aws_iam_role.awsconfig_management_global_org.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}
