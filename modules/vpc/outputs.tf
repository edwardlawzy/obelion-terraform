output "vpc_id" { value = aws_vpc.vpc.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }


output "asg_sg" {
  value = aws_security_group.asg_sg.id
}

output "db_sng_id" {
  value = aws_db_subnet_group.rds_sng.id
}

output "db_sng_name" {
  value = aws_db_subnet_group.rds_sng.name
}

output "db_sg" {
  value = aws_security_group.rds_sg.id
}
