terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name

  vpc_private_subnet_prefix = var.vpc_private_subnet_prefix
  vpc_public_subnet_prefix = var.vpc_public_subnet_prefix

  vpc_private_subnet = var.vpc_public_subnet
  vpc_public_subnet = var.vpc_public_subnet
  vpc_subnet_count = var.vpc_subnet_count

  vpc_cidr       = var.vpc_cidr
  #public_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
  #private_subnets = ["192.168.101.0/24", "192.168.102.0/24"]
  aws_region     = var.aws_region
}

module "app" {
  source = "./modules/eks"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids

  #bastion_subnet_ids = [module.vpc.public_subnet_ids]
  # bastion_sg_id = module.vpc.asg_sg.id

  keypair_name = "edward"

  instance_type         = var.instance_type
  desired_capacity      = 2
  max_capacity          = 4
  min_capacity          = 2

  

  project_name = var.project_name
  ami_type = "AL2023_x86_64_STANDARD"
}