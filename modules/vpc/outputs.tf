output "vpc_id" { value = aws_vpc.vpc.id } //VPC ID
output "public_subnet_ids" { value = aws_subnet.public[*].id } //VPC Public Subnet IDs
output "private_subnet_ids" { value = aws_subnet.private[*].id } //VPC Private Subnet IDs

//Security Group ID for EC2 Instances (Backend and Frontend)
output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

//Subnet Group ID for DB Instance
output "db_sng_id" {
  value = aws_db_subnet_group.rds_sng.id
}
//Subnet Group Name for DB Instance
output "db_sng_name" {
  value = aws_db_subnet_group.rds_sng.name
}
//Security Group ID for DB Instance
output "db_sg" {
  value = aws_security_group.rds_sg.id
}
