provider "aws" {
  region = var.aws_region
}

# Fetch existing VPC
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name] # Ensure this tag exists on your VPC
  }
}


# Fetch existing public subnet using Subnet ID
data "aws_subnet" "public" {
  id = "subnet-0c634989343c90a5a"
}


# # Fetch existing private subnets
# data "aws_subnet" "private" {
#   filter {
#     name   = "tag:Name"
#     values = [var.private_subnet_name] # Ensure this tag exists on your subnet
#   }
# }

module "alb" {
  source = "./modules/alb"

  environment     = var.environment
  vpc_id          = data.aws_vpc.existing.id
  subnet_id       = data.aws_subnet.public.id
  instance_id     = module.ec2.instance_id
  certificate_arn = var.certificate_arn
  domain_name     = var.domain_name
  hosted_zone_id  = var.hosted_zone_id
}

module "ec2" {
  source = "./modules/ec2"

  environment           = var.environment
  vpc_id                = data.aws_vpc.existing.id
  subnet_id             = data.aws_subnet.public.id
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  alb_security_group_id = module.alb.security_group_id
  docker_image          = var.docker_image
  docker_port           = var.docker_port
}

module "rds" {
  source = "./modules/rds"

  environment           = var.environment
  vpc_id                = data.aws_vpc.existing.id
  subnet_id             = data.aws_subnet.private.id
  ec2_security_group_id = module.ec2.security_group_id
  engine_version        = var.engine_version
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  instance_class        = var.instance_class
}
