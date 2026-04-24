output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway."
  value       = aws_internet_gateway.main.id
}

output "dashboard_instance_id" {
  description = "ID of the dashboard EC2 instance."
  value       = aws_instance.dashboard.id
}

output "dashboard_public_ip" {
  description = "Public IP address of the dashboard EC2 instance."
  value       = aws_instance.dashboard.public_ip
}

output "counting_instance_id" {
  description = "ID of the counting EC2 instance."
  value       = aws_instance.counting.id
}

output "dashboard_security_group_id" {
  description = "ID of the dashboard security group."
  value       = aws_security_group.dashboard.id
}

output "counting_security_group_id" {
  description = "ID of the counting security group."
  value       = aws_security_group.counting.id
}
