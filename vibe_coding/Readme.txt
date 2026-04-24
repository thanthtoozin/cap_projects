Generate AWS Terraform files main.tf, variables.tf, and outputs.tf for:

one VPC

one public subnet
one private subnet

one internet gateway
one public route table with 0.0.0.0/0 to IGW
route table association for public subnet

dashboard security group with ports 80, 22 from mycomputerIP, and 9002 open
counting security group allowing 9001 and 22 only from dashboard SG

latest Ubuntu 22.04 AMI
dashboard EC2 in public subnet with public IP
counting EC2 in private subnet without public IP


my_ip               = "2.220.45.156/32"         <- Need to change
aws_profile         = "thant-dev-aws-profile"   <- Need to change
key_name            = "thant_dev_ec2_keypair"   <- Need to change
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
region              = "eu-west-2"