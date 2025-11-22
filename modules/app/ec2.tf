# # resource "null_resource" "edit_file_with_sed" {
# #   provisioner "local-exec" {
# #     command = "sed -i 's/localhost/${aws_db_instance.wordpress_db.address}/g' /home/ec2-user/wp-config.php.j2" 
# #   }
# # }


# data "aws_ami" "amazon_linux_2023" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
# }


# resource "aws_instance" "wordpress_app" {
#   count                  = 2
#   ami                    = data.aws_ami.amazon_linux_2023.id
#   instance_type          = var.instance_type
#   key_name               = var.keypair_name
#   subnet_id              = var.public_subnet_ids[count.index]
#   vpc_security_group_ids = [var.asg_sg]
#   associate_public_ip_address = true

#   tags = {
#     Name = "ansible-wordpress-node-${count.index + 1}"
#   }

#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "sudo yum update -y",
#   #     "sudo yum install python3 -y"
#   #   ]

#   #   connection {
#   #     type        = "ssh"
#   #     user        = "ec2-user"
#   #     private_key = file("/home/ec2-user/edward.pem")
#   #     host        = self.public_ip
#   #   }
#   # }

#   # provisioner "local-exec" {
#   #   command = <<-EOT
#   #     echo "${self.public_ip} ansible_ssh_private_key_file=/home/ec2-user/edward.pem ansible_user=ec2-user" > /tmp/ansible-inventory
#   #     ansible-playbook -i /tmp/ansible-inventory /home/ec2-user/playbook.yml
#   #   EOT

#   #   interpreter = ["/bin/bash", "-c"]
#   #   when        = create
#   # }
# }