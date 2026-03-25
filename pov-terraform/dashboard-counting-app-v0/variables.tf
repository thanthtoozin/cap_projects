variable "region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "eu-west-2"
}

variable "aws_profile" {
  description = "AWS CLI profile name used by Terraform"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC network"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (used by the dashboard VM)"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (used by the counting VM)"
  type        = string
}

variable "my_ip" {
  description = "Public IP address in CIDR format used to allow SSH access (port 22)"
  type        = string
}

variable "key_name" {
  description = "Name of the existing AWS EC2 key pair used for SSH access to instances"
  type        = string
}


# EC2 (VM) (with Security Group)
#    ↓
# Subnet
#    ↓
# Route Table
#    ↓
# Internet Gateway
#    ↓
# Internet