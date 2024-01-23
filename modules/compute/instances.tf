# Create ssh rsa key pair to connect to instances
resource "aws_key_pair" "key-pair" {
key_name      = "key-pair-mike-${terraform.workspace}"
public_key    = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm     = "RSA"
rsa_bits      = 4096
}

resource "local_file" "file" {
content       = tls_private_key.rsa.private_key_pem
filename      = "key-pair-mike-${terraform.workspace}"
}

#Move the key pair to the .ssh home directory
resource "null_resource" "move_key_to_ssh_directory" {
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ~/.ssh
      mv ${local_file.file.filename} ~/.ssh/${aws_key_pair.key-pair.key_name}
      chmod 600 ~/.ssh/${aws_key_pair.key-pair.key_name}
    EOT
  }
}


data "aws_subnet" "existing_subnet" {
  filter {
    name   = "tag:Name"
    values = ["tf-vpc-mike-subnet-public1-ap-south-1a"]
  }
}

data "aws_security_groups" "existing_security_groups" {
  filter {
    name   = "group-name"
    values = ["mike-tf-sg"]
  }
}


data "aws_iam_role" "existing" {
  name = "spid-ec2-ecr-access"
}

resource "aws_instance" "name" {
    availability_zone = var.az[0]
    ami = var.ami_id
    instance_type = var.inst_type
    subnet_id = data.aws_subnet.existing_subnet.id
    vpc_security_group_ids = [data.aws_security_groups.existing_security_groups.ids[0]]
    iam_instance_profile   = data.aws_iam_role.existing.name
    associate_public_ip_address = true
    key_name = aws_key_pair.key-pair.key_name
    tags = {
      Name = "ted-mike-${terraform.workspace}"
    }

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${aws_key_pair.key-pair.key_name}")
      host        = self.public_ip
  }

  provisioner "file" {
    source      = "./modules/compute/init.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "file" {
    source      = "./docker-compose.yaml"
    destination = "/tmp/docker-compose.yaml"
  }

  provisioner "file" {
    source      = "./nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/init.sh",
      "/tmp/init.sh",
      "cd /tmp/",
      "ls",
      "sudo sg docker -c 'docker-compose up -d --build' || true",
    ]
  }
}