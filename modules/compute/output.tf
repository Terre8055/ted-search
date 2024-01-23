output "ec2_ip" {
  description = "IP of instance"
  value = aws_instance.name.public_ip
  # sensitive = true
}

output "ec2_access_port" {
  description = "Access Port of instance"
  value = 8077
}

output "last_modified" {
  value = timestamp()
}