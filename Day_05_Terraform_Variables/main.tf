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
  region = "ap-south-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "manu-bucket-terraform-2026"
}

variable "Tags_Environment" {
  description = "The AWS tags for the environement"
  type        = string
  default     = "development"
}

#Terraform locals allow you to assign a name to an expression/value and reuse it throughout your Terraform configuration.
locals{
  bucket_name = "${var.bucket_name}${var.Tags_Environment}.s3"
  vpc_name = "${var.Tags_Environment}-VPC"
}

#Create S3 bucket
resource "aws_s3_bucket" "manu_bucket" {
    bucket = local.bucket_name
    tags = {
        Name = local.bucket_name
        environment = var.Tags_Environment
    }
} 

#Create VPC 
resource "aws_vpc" "manu_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      environment = var.Tags_Environment
      #concatenate the variable value with a string using ${}
      Name = local.vpc_name
    }
}
resource "aws_subnet" "manu_public_subnet" {
    vpc_id = aws_vpc.manu_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
      environment = var.Tags_Environment
      Name = "Dev-Public-Subnet"
    }
}
resource "aws_subnet" "manu_private_subnet" {
    vpc_id = aws_vpc.manu_vpc.id
    cidr_block = "10.0.2.0/24"
    tags = {
      environment = var.Tags_Environment
      Name = "Dev-Private-Subnet"
    }
}

resource "aws_internet_gateway" "manu_igw" {
    vpc_id = aws_vpc.manu_vpc.id
    tags = {
      environment = var.Tags_Environment
      Name = "Dev-IGW"
    }
}

resource "aws_route_table" "manu_public_rt" {
    vpc_id = aws_vpc.manu_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.manu_igw.id
    }

    tags = {
      environment = var.Tags_Environment
      Name = "Dev-Public-Route-Table"
    }
}

resource "aws_route_table_association" "manu_public_rt_assoc" {
    subnet_id = aws_subnet.manu_public_subnet.id
    route_table_id = aws_route_table.manu_public_rt.id
}

resource "aws_security_group" "manu_sg" {
    name        = "manu-sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = aws_vpc.manu_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "manu_ec2" {
    ami                         = "ami-035827357e3c7e810"
    instance_type               = "t3.micro"
    subnet_id                   = aws_subnet.manu_public_subnet.id
    vpc_security_group_ids      = [aws_security_group.manu_sg.id]
    associate_public_ip_address  = true
    count                       = 2

    tags = {
      environment = var.Tags_Environment
      Name = "Dev-EC2"
    }
}

#output variables
output "bucket_name" {
  value = aws_s3_bucket.manu_bucket.bucket
} 

output "vpc_id" {
  value = aws_vpc.manu_vpc.id
}

output "public_instance_ids"{
  value = aws_instance.manu_ec2.*.id
}

output "public_ips"{
  value = aws_instance.manu_ec2.*.public_ip
}