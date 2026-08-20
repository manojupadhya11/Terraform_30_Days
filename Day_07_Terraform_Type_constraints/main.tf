terraform{
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version  = ">= 1.15.0"
}

provider "aws" {
  region = tolist(var.region[0])
}



variable "Tags_Environment" {
  description = "The AWS tags for the environement"
  type        = string
  default     = "development"
}


resource "aws_instance" "manu_ec2" {
    ami                         = "ami-035827357e3c7e810"
    instance_type               = var.instance_type_pool[0]
    count                       = var.instance_count
    associate_public_ip_address  = var.allow
    monitoring                   = var.allow
    tags = {
      environment = var.Tags_Environment
      Name = "Dev-EC2"
    }
}

resource "aws_security_group" "manu_sg" {
    name        = "manu-sg"
    description = "Allow SSH and HTTP inbound traffic"
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.cidr_block[0]]
    }

    ingress {
        from_port   = 80
        to_port     = 80
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


output "public_ips"{
  value = aws_instance.manu_ec2.*.public_ip
}
