module "ec2_webserver_vpc" {
  source = "./vpc"
  provider_role                 = var.provider_role
  private_subnets_cidr_map      = var.private_subnets_cidr_map
  public_subnets_cidr_map       = var.public_subnets_cidr_map
  vpc_cidr_block                = var.vpc_cidr_block
  common_tags_map               = local.common_tags_map
  common_name_prefix            = local.common_name_prefix
  environment                   = var.environment
}

module "ec2_webserver" {
  source = "./ec2"
  provider_role                 = var.provider_role
  aws_region                    = var.aws_region
  subnet_ids                    = module.ec2_webserver_vpc.public_subnet_ids
  vpc_id                        = module.ec2_webserver_vpc.vpc_id
  image_id                      = var.image_id
  instance_type                 = var.instance_type
  common_tags_map               = local.common_tags_map
  common_name_prefix            = local.common_name_prefix
  environment                   = var.environment
  webserver_port                = var.webserver_port
  lb_port                       = var.lb_port
}

module "ec2_iam" {
  source = "./iam"
  provider_role                 = var.provider_role
  common_tags_map               = local.common_tags_map
  common_name_prefix            = local.common_name_prefix
  environment                   = var.environment
}

locals {
  common_name_prefix = format("%s-%s-%s-%s", var.project, var.environment, local.region_short_map[var.aws_region], var.purpose)
  common_tags_map = {
    Project     = var.project
    Environment = var.environment
    Region      = var.aws_region
    Purpose     = var.purpose
    Owner       = var.resource_owner
  }
    region_short_map = {
    "ap-south-1" = "aps1"
  }
}
