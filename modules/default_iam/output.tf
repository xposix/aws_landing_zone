output "idp_provider_arn" {
  description = "IAM Identify Provider ARN for the Google Auth integration"
  value       = aws_iam_saml_provider.idp.0.arn
}