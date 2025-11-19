module "vpc" {
  source   = "../../modules/vpc"
  project  = var.project
  vpc_cidr = var.vpc_cidr
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "igw_id" {
  value = module.vpc.igw_id
}
