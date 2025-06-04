# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# sources: https://github.com/HarryNash/terraform-minecraft, https://www.endpointdev.com/blog/2020/07/automating-minecraft-server/

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "minecraft_server" {
  ami                    = "ami-08c40ec9ead489470" 
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  key_name               = aws_key_pair.minecraft_key.key_name
  user_data     = filebase64("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "Minecraft-Server"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-security-group"
  description = "mcsg rules"

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-keypair-tf"
  public_key = file("~/.ssh/minecraft_key.pub")
}



output "public_ip" {
  value       = aws_instance.minecraft_server.public_ip
  description = "Minecraft Server Public IP"
}

output "ssh_command" {
  value       = "ssh -i ~/.ssh/minecraft_key ubuntu@${aws_instance.minecraft_server.public_ip}"
  description = "Command to connect via SSH"
}
