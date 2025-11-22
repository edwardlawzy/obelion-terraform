resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  identifier             = "${var.project_name}-db-instance"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_sng_name
  vpc_security_group_ids = [var.db_sg]
  skip_final_snapshot    = true
  publicly_accessible    = false
}