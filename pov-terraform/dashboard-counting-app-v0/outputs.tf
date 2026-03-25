output "dashboard_public_ip" {
  value = aws_instance.dashboard.public_ip
}

output "counting_private_ip" {
  value = aws_instance.counting.private_ip
}