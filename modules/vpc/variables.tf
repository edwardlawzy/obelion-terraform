variable "vpc_cidr" {}
#variable "public_subnets" { type = list(string) }
#variable "private_subnets" { type = list(string) }
variable "aws_region" {}
variable "project_name" {type = string} 

variable "vpc_private_subnet" {type = string}
variable "vpc_public_subnet" {type = string} 
variable "vpc_subnet_count" {type = string} 

variable "vpc_private_subnet_prefix" {type = string}
variable "vpc_public_subnet_prefix" {type = string} 


variable "new_bits" {
  description = "The number of additional bits for subnet allocation (e.g., 8 for /24 subnets from a /16 VPC)."
  type        = number
  default     = 8
}
