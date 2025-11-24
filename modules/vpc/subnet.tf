//Public Subnet
resource "aws_subnet" "public" {
  count             = var.vpc_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_public_subnet_prefix, var.new_bits, count.index+101) //Automated Subnet Creation for multiple subnet (Subnet Count>1)
  # Example:
  # var.vpc_public_subnet_prefix  = 192.168.100.0/16
  # var.new_bits                  =              /8
  # count.index+1                 =  0.0.(0+101).0/0
  # Final Subnet                  = 192.168.101.0/24
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

//Private Subnet
resource "aws_subnet" "private" {
  count             = var.vpc_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_private_subnet_prefix, var.new_bits, count.index+1) //Automated Subnet Creation for multiple subnet (Subnet Count>1)
  # Example:
  # var.vpc_private_subnet_prefix = 192.168.1.0/16
  # var.new_bits                  =            /8
  # count.index+1                 =  0.0.(0+1).0/0
  # Final Subnet                  = 192.168.1.0/24
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

//DB Instance Subnet Group
resource "aws_db_subnet_group" "rds_sng" {
  name       = "${var.project_name}-rds-sng"
  subnet_ids = aws_subnet.public.*.id //Configure the Subnet IDs for RDS Instance to be all the public subnets created in the above public subnet section
  tags       = { Name = "RDS Subnet Group" }
}

//Note: RDS should be in a private subnet not in public subnet and this decision was due to the graph given in the assessment that put all instances and DB in the same subnet
//The DB will not have internet access because it will not be assigned a public IP