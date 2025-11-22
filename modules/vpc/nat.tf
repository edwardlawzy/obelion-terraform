resource "aws_eip" "nat" {
  domain        = "vpc"
  tags = { Name = "${var.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # Place NAT GW in first public subnet

  tags = {
    Name = "${var.project_name}-nat"
  }
}
