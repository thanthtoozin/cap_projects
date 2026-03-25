provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  public_subnets  = var.aws_vpc_public_subnets
  private_subnets = var.aws_vpc_private_subnets

  enable_nat_gateway = false

  tags = {
    Name = "cap-project"
  }
}

module "dashboard_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "dashboard-sg"
  description = "Security group for dashboard VM"
  vpc_id      = module.aws_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 9002
      to_port     = 9002
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow dashboard app access from internet"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.my_ip
      description = "Allow SSH from my IP"
    }
  ]

  egress_rules = ["all-all"]
}

module "counting_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "counting-sg"
  description = "Security group for counting VM"
  vpc_id      = module.aws_vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 9001
      to_port                  = 9001
      protocol                 = "tcp"
      description              = "Allow counting app access from dashboard SG"
      source_security_group_id = module.dashboard_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "Allow SSH from dashboard SG"
      source_security_group_id = module.dashboard_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "dashboard_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "dashboard-vm"

  ami = data.aws_ami.ubuntu.id

  instance_type          = "t3.micro"
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = module.aws_vpc.public_subnets[0]
  vpc_security_group_ids = [module.dashboard_sg.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = "dashboard-vm"
  }
}

module "counting_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "counting-vm"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  monitoring             = false
  subnet_id              = module.aws_vpc.private_subnets[0]
  vpc_security_group_ids = [module.counting_sg.security_group_id]

  associate_public_ip_address = false

  tags = {
    Name = "counting-vm"
  }
}