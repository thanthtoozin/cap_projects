output "dashboard_public_ip" {
  value = module.dashboard_ec2.public_ip
}

output "counting_private_ip" {
  value = module.counting_ec2.private_ip
}

output "vpc_id" {
  value = module.aws_vpc.vpc_id
}