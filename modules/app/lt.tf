resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type
  key_name      = var.keypair_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.asg_sg]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
# sed -i 's/database_name_here/${var.db_address}/g' /var/www/html/wp-config.php
# sed -i 's/username_here/${var.db_username}/g' /var/www/html/wp-config.php
# sed -i 's/password_here/${var.db_password}/g' /var/www/html/wp-config.php
 sed -i 's/192.168.101.101/${var.db_address}/g' /var/www/html/wp-config.php
EOF
)
}