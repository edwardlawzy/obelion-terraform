#---------------------------#
#--------- General ---------#
#---------------------------#

aws_region      = "us-east-1"
project_name    = "edward-obelion"
keypair_name    = "edward"
instance_type   = "t3.micro"


#-----------------------#
#--------- App ---------#
#-----------------------#

volume_size = 8

#----------------------#
#--------- DB ---------#
#----------------------#

db_username         = "admin"
db_password         = "password"
db_name		        = "mydb"
db_instance_class   = "db.t4g.micro"
db_engine_version   = "8.0"

#---------------------------#
#--------- Network ---------#
#---------------------------#

vpc_subnet_count = "1"
vpc_cidr = "192.168.0.0/16"
vpc_private_subnet = "192.168.1.0/24"
vpc_public_subnet = "192.168.100.0/24"

vpc_private_subnet_prefix = "192.168.1.0/16"
vpc_public_subnet_prefix = "192.168.100.0/16"

new_bits = 8

#----------------------#
#--------- S3 ---------#
#----------------------#

bucket_name	   = "edward-terraform-s3"
