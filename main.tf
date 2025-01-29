provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "alb" {
  source = "./modules/alb"

  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_id
  instance_id     = module.ec2.instance_id
  certificate_arn = var.certificate_arn
  domain_name     = var.domain_name
  hosted_zone_id  = var.hosted_zone_id
}

module "ec2" {
  source = "./modules/ec2"

  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.public_subnet_id
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  alb_security_group_id = module.alb.security_group_id
  docker_image          = var.docker_image
  docker_port           = var.docker_port
}

module "rds" {
  source = "./modules/rds"

  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.private_subnet_id
  ec2_security_group_id = module.ec2.security_group_id
  engine_version        = var.engine_version
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  instance_class        = var.instance_class
}
