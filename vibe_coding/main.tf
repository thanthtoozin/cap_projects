terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vibe-coding-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_az

  tags = {
    Name = "vibe-coding-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_subnet_az

  tags = {
    Name = "vibe-coding-private-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vibe-coding-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "vibe-coding-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "dashboard" {
  name        = "dashboard-sg"
  description = "Security group for dashboard EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH from your computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description      = "Dashboard application port"
    from_port        = 9002
    to_port          = 9002
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dashboard-sg"
  }
}

resource "aws_security_group" "counting" {
  name        = "counting-sg"
  description = "Security group for counting EC2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Counting app from dashboard SG"
    from_port       = 9001
    to_port         = 9001
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard.id]
  }

  ingress {
    description     = "SSH from dashboard SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "counting-sg"
  }
}

resource "aws_instance" "dashboard" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.dashboard_instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.dashboard.id]
  key_name                    = var.key_pair_name

  tags = {
    Name = "vibe_coding-dashboard-instance"
  }
}

resource "aws_instance" "counting" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.counting_instance_type
  subnet_id              = aws_subnet.private.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.counting.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "vibe_coding-counting-instance"
  }
}
