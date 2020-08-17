module "networking-primary-region-vpc1" {
  source            = "../../modules/tgw_network"
  connectivity_type = "tgw"
  vpc_name          = local.primary-region-vpc1.vpc_name
  vpc_cidr          = local.primary-region-vpc1.vpc_cidr
  n_of_AZs          = local.primary-region-vpc1.n_of_AZs

  project_tags = local.project_tags

}
