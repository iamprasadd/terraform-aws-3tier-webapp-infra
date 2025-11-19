module "vpc" {
  source   = "../../modules/vpc"
  region   = var.region
  project  = var.project
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source       = "../../modules/subnets"
  project      = var.project
  azs          = var.azs
  vpc_id       = module.vpc.vpc_id
  public_cidrs = var.public_subnets
  app_cidrs    = var.app_subnets
  data_cidrs   = var.data_subnets
}

module "routing" {
  source            = "../../modules/routing"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.igw_id
  project           = var.project
  public_subnet_ids = module.subnets.public_subnet_ids
  app_subnet_ids    = module.subnets.app_subnet_ids
  data_subnet_ids   = module.subnets.data_subnet_ids
}

module "security_groups" {
  source  = "../../modules/security-groups"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "alb_asg" {
  source  = "../../modules/alb_asg"
  project = var.project
  region  = var.region

  public_subnet_ids = module.subnets.public_subnet_ids
  app_subnet_ids    = module.subnets.app_subnet_ids

  alb_sg_id = module.security_groups.alb_sg_id
  app_sg_id = module.security_groups.app_sg_id

  instance_type = var.instance_type
  key_name      = var.key_name
  min_size      = var.min_size
  max_size      = var.max_size
  desired_size  = var.desired_size

  db_endpoint = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
  db_username = module.rds.db_username
  db_password = var.db_password

}

module "rds" {
  source        = "../../modules/rds"
  project       = var.project
  environment   = "dev"
  db_subnet_ids = module.subnets.data_subnet_ids
  db_sg_id      = module.security_groups.db_sg_id

  db_name     = "appdb"
  db_username = "appuser"
  db_password = var.db_password
}



output "alb_dns_name" {
  value = module.alb_asg.alb_dns_name
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "nat_gateway_ids" {
  value = module.routing.nat_gateway_ids
}

output "public_route_table_id" {
  value = module.routing.public_route_table_id
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}
output "app_subnet_ids" {
  value = module.subnets.app_subnet_ids
}
output "data_subnet_ids" {
  value = module.subnets.data_subnet_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}