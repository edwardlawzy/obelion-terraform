variable "vpc_cidr" {} //VPC CIDR
variable "aws_region" {} //AWS Region
variable "project_name" {type = string} //Project Name to be used as a prefix

variable "vpc_private_subnet" {type = string} //VPC Private Subnet
variable "vpc_public_subnet" {type = string}  //VPC Public Subnet
variable "vpc_subnet_count" {type = string}   //VPC Subnet Count that will be used to automate the subnet creation

variable "vpc_private_subnet_prefix" {type = string} //VPC Private Subnet Prefix that is used to automate the subnet creation (192.168.1.0/16)
variable "vpc_public_subnet_prefix" {type = string} //VPC Public Subnet Prefix that is used to automate the subnet creation (192.168.100.0/16)


variable "new_bits" {
  description = "The number of additional bits for subnet allocation (e.g., 8 for /24 subnets from a /16 VPC)."
  type        = number
  default     = 8
}
