terraform {
    #Provider manager Cloud Service Provider example AWS, Azure
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
  
  #Terraform Version required to run this configuration
  required_version = ">= 1.15.0"
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
    instance_type = "t3.micro"
    ami = "ami-035827357e3c7e810"
}