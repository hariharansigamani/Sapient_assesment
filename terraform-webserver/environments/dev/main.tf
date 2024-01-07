module "ec2-webserver" {
  source = "./../../modules"

  provider_role                 = var.provider_role
  resource_owner                = var.resource_owner
  aws_region                    = var.aws_region
  aws_region_short              = var.aws_region_short
  environment                   = var.environment
  account_id                    = var.account_id

  vpc_cidr_block                = var.vpc_cidr_block
  public_subnets_cidr_map       = var.public_subnets_cidr_map
  private_subnets_cidr_map      = var.private_subnets_cidr_map
  image_id                      = var.image_id
  instance_type                 = var.instance_type
  
  project                       = var.project
  purpose                       = var.purpose
  shared_aws_account_id         = var.shared_aws_account_id
}