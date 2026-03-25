variable "region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "key_name" {
  type = string
}

variable "aws_vpc_name" {
  type = string
}

variable "aws_vpc_cidr" {
  type = string
}

variable "aws_vpc_azs" {
  type = list(string)
}

variable "aws_vpc_public_subnets" {
  type = list(string)
}

variable "aws_vpc_private_subnets" {
  type = list(string)
}