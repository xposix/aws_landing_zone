resource "aws_iam_saml_provider" "idp" {
  count                  = var.enable_saml_provider ? 1 : 0
  name                   = var.provider_name
  saml_metadata_document = file(var.saml_metadata_document_path == "" ? "${path.module}/assets/GoogleIDPMetadata.xml" : var.saml_metadata_document_path)
}
