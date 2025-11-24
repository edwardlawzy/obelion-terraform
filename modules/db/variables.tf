variable "db_name" {} //Database Name
variable "db_username" {} //Database Username
variable "db_password" {} //Database Password
variable "db_instance_class" {} //Database Instance Type
variable "db_engine_version" {} //Database Engine Version (MySQL)
variable "db_sng_id" {type = string} //Database Subnet Group ID
variable "db_sng_name" {type = string}  //Database Subnet Group Name
variable "db_sg" {type = string}  //Database Security Group

variable "project_name" {type = string} //Project Name to be used as a prefix