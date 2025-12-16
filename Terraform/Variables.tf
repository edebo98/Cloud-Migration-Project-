variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}

variable "key_name" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}

variable "instance_type" {}
variable "bucket_name" {}

