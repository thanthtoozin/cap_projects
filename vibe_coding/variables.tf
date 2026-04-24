variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "eu-west-2"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for provider authentication."
  type        = string
  default     = "thant-dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_az" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "eu-west-2a"
}

variable "private_subnet_az" {
  description = "Availability zone for the private subnet."
  type        = string
  default     = "eu-west-2b"
}

variable "my_ip" {
  description = "Your computer IP address to allow SSH access from. Provide a single IP address or CIDR block."
  type        = string
  default     = "2.220.45.156/32"
}

variable "key_pair_name" {
  description = "Key pair name for EC2 SSH access."
  type        = string
  default     = "thant_dev_ec2_keypair"
}

variable "dashboard_instance_type" {
  description = "EC2 instance type for the dashboard server."
  type        = string
  default     = "t3.micro"
}

variable "counting_instance_type" {
  description = "EC2 instance type for the counting server."
  type        = string
  default     = "t3.micro"
}
