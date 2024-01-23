output "ec2_ip" {
    value = module.compute.ec2_ip
    # sensitive = true
}

output "ec2_access_port" {
  value = module.compute.ec2_access_port
}

output "last_modified" {
  value = module.compute.last_modified
}