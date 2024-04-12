# TO_FILL
resource "aws_organizations_organizational_unit" "engineering" {
  name      = "engineering"
  parent_id = aws_organizations_organization.my_organisation.roots.0.id
}

resource "aws_organizations_organizational_unit" "cross_functional_teams" {
  name      = "cross_functional_teams"
  parent_id = aws_organizations_organization.my_organisation.roots.0.id
}
