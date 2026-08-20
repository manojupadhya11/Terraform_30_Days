# Input Variables - Values provided to Terraform configuration

#Example for variable type set of string
variable "region"{
    description = "AWS region"
    type        = set(string)
    default     = ["ap-south-1","us-east-1","us-west-1"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "instance_count"{
    description = "Number of EC2 instances to create"
    type        = number
    default     = 2
}
variable "allow" {
  type = bool
  default = true
}


variable "deny" {
  type = bool
  default = false
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/16","192.168.0.0/16","172.16.0.0/12"]
}

variable "instance_type_pool" {
  description = "Type of EC2 instance"
  type        = list(string)
  default     = ["t3.micro","t3.small","t3.medium","d2.xlarge"]
}