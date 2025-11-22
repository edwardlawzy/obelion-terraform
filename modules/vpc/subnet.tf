
resource "aws_subnet" "public" {
  count             = var.vpc_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_public_subnet_prefix, var.new_bits, count.index+101)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = var.vpc_subnet_count
  vpc_id            = aws_vpc.vpc.id
  #cidr_block        = var.private_subnets[count.index]
  cidr_block = cidrsubnet(var.vpc_private_subnet_prefix, var.new_bits, count.index+1)########
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "rds_sng" {
  name       = "${var.project_name}-rds-sng"
  subnet_ids = aws_subnet.private.*.id
  #subnet_ids = aws_subnet.public[0].id
  tags       = { Name = "RDS Subnet Group" }
}