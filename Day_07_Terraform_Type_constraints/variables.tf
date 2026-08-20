# Input Variables - Values provided to Terraform configuration

#Example for variable type set of string set of string wont allow duplicate values in the list. It will only allow unique values in the list.
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

# List of string used to create a list of possible values for the variable. List of string will allow duplicate values in the list. It will allow same values in the list.
variable "instance_type_pool" {
  description = "Type of EC2 instance"
  type        = list(string)
  default     = ["t3.micro","t3.small","t3.medium","d2.xlarge"]
}

#map variable type is used to create a key-value pair. It allows you to define a set of named values that can be accessed using their corresponding keys.
variable "Tags" {
  description = "The AWS tags for the environement"
  type        = map(string)
  default      = {
    Environment = "development"
    Owner       = "Manu"
  }
}

#dict variable type is used to create a collection of key-value pairs. It allows you to define a set of named values that can be accessed using their corresponding keys.
variable "Tags_dict" {
  description = "The AWS tags for the environement"
  type        = object({
    Environment = string
    Owner       = string
  })
  default     = {
    Environment = "development"
    Owner       = "Manu"
  }
}


#Tuple variable type is used to create a collection of values of different types. It allows you to define a fixed-size ordered list of values that can be accessed using their corresponding index.
variable "ingress_values"{
    description = "The AWS ingress values for the security group"
    type        = tuple([number, string, number])
    default = [443, "tcp", 443]

}