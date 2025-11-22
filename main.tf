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

module "db" {
  source = "./modules/db"

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  db_engine_version = var.db_engine_version
  db_sng_id         = module.vpc.db_sng_id
  db_sng_name       = module.vpc.db_sng_name
  db_sg             = module.vpc.db_sg

  project_name      = var.project_name
  
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Frontend Machine
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.keypair_name
  subnet_id     = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true
  security_groups = [module.vpc.asg_sg]

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "${var.project_name}-Frontend"
  }
}

# Backend Machine
resource "aws_instance" "backend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.keypair_name
  subnet_id     = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true
  security_groups = [module.vpc.asg_sg]

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "${var.project_name}-Backend"
  }
}