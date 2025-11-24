// Output the RDS DB Address to be used in main.tf
output "db_address" {
  value = aws_db_instance.db.address
}
