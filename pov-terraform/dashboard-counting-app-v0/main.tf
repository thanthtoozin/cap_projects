provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

# ---------------- VPC ----------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "cap-project-vpc"
  }
}

# ---------------- SUBNETS ----------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private-subnet"
  }
}

# ---------------- INTERNET GATEWAY ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# ---------------- ROUTE TABLE ----------------
# This block works public subnet able to access the internet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------- SECURITY GROUPS ----------------

# Dashboard SG
resource "aws_security_group" "dashboard_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dashboard-security-group"
  }
}

# Counting SG
resource "aws_security_group" "counting_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 9001
    to_port         = 9001
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.dashboard_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "counting-security-group"
  }
}

# ---------------- AMI (Ubuntu latest) ----------------
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ---------------- EC2 INSTANCES ----------------

# Dashboard VM (PUBLIC)
resource "aws_instance" "dashboard" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.dashboard_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "dashboard-vm"
  }
}

# Counting VM (PRIVATE)
resource "aws_instance" "counting" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.counting_sg.id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  tags = {
    Name = "counting-vm"
  }
}