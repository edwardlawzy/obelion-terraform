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

# resource "aws_launch_template" "frontend_lt" {
#   name_prefix   = "${var.project_name}-Frontend-lt"
#   image_id      = var.wordpress_ami_id
#   instance_type = var.instance_type
#   key_name      = var.keypair_name

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [var.asg_sg]
#   }

#   user_data = base64encode(<<EOF
# #!/bin/bash
# # sed -i 's/database_name_here/${var.db_address}/g' /var/www/html/wp-config.php
# # sed -i 's/username_here/${var.db_username}/g' /var/www/html/wp-config.php
# # sed -i 's/password_here/${var.db_password}/g' /var/www/html/wp-config.php
#  sed -i 's/192.168.101.101/${var.db_address}/g' /var/www/html/wp-config.php
# EOF
# )
# }

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

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "${var.project_name}-backend-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.keypair_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.vpc.asg_sg]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo "Install Started.." > /home/ubuntu/output.txt
sudo apt update -y >> /home/ubuntu/output.txt
sudo apt install software-properties-common -y >> /home/ubuntu/output.txt
sudo add-apt-repository ppa:ondrej/php -y >> /home/ubuntu/output.txt
sudo apt update -y >> /home/ubuntu/output.txt
sudo apt install php8.3 -y >> /home/ubuntu/output.txt
sudo add-apt-repository ppa:ondrej/php -y >> /home/ubuntu/output.txt
sudo apt update -y >> /home/ubuntu/output.txt
sudo apt install php8.3-xml php8.3-curl php8.3-mysql php8.3-mbstring -y >> /home/ubuntu/output.txt

echo "Done Installing PHP.." >> /home/ubuntu/output.txt

sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" >> /home/ubuntu/output.txt
sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" >> /home/ubuntu/output.txt
sudo php composer-setup.php >> /home/ubuntu/output.txt
sudo php -r "unlink('composer-setup.php');" >> /home/ubuntu/output.txt
sudo mv composer.phar /usr/local/bin/composer >> /home/ubuntu/output.txt

echo "Done Installing Composer.." >> /home/ubuntu/output.txt

cd /var/www/html >> /home/ubuntu/output.txt
sudo git clone https://github.com/edwardlawzy/obelion-backend.git >> /home/ubuntu/output.txt
cd obelion-backend >> /home/ubuntu/output.txt
echo "Repo Cloned.." >> /home/ubuntu/output.txt

sudo composer install --no-interaction --prefer-dist --optimize-autoloader >> /home/ubuntu/output.txt

sudo php artisan config:clear 
echo "Config Cleared.." >> /home/ubuntu/output.txt
sudo php artisan cache:clear
echo "Cache Cleared.." >> /home/ubuntu/output.txt
sudo php artisan key:generate
echo "Key Generated.." >> /home/ubuntu/output.txt




sed -i '/^DB_CONNECTION=/s/=sqlite/mysql/' .env.example
sed -i '/^# DB_PORT=3306/s/# DB_PORT=3306/DB_PORT=3306/' .env.example
sed -i '/^# DB_DATABASE=laravel/s/# DB_DATABASE=laravel/DB_DATABASE=${var.db_name}/' .env.example
sed -i '/^# DB_USERNAME=root/s/# DB_USERNAME=root/DB_USERNAME=${var.db_username}/' .env.example
sed -i '/^# DB_PASSWORD=/s/# DB_PASSWORD=/DB_PASSWORD=${var.db_password}/' .env.example
sed -i '/^# DB_HOST=127.0.0.1/s/# DB_HOST=127.0.0.1/DB_HOST=${module.db.db_address}/' .env.example


sudo cp .env{.example,}
echo ".env File Created.." >> /home/ubuntu/output.txt
sudo php artisan serve --host=0.0.0.0 &
echo "Serving.." >> /home/ubuntu/output.txt
EOF
)
}

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
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  tags = {
    Name = "${var.project_name}-Backend"
  }
}