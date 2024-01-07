variable "provider_role" {
  default     = "arn:aws:iam::944200606058:role/hari-devops-role-assume-admin"
  description = "The IAM role from the DevOps AWS account to be assumed. Needs to allow all creation/destruction of all the resources from this code"
}

variable "resource_owner" {
  default = "Hariharan"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "aws_region_short" {
  default = "aps1"
}

variable "environment" {
  default = "dev"
}

variable "account_id" {
  default = "944200606058"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "private_subnets_cidr_map" {
  type = map(string)
  default = {
    "ap-south-1a" = "10.0.0.0/24"
    "ap-south-1b" = "10.0.1.0/24"
    "ap-south-1c" = "10.0.2.0/24"
  }
}

variable "public_subnets_cidr_map" {
  type = map(string)
  default = {
    "ap-south-1a" = "10.0.3.0/24"
    "ap-south-1b" = "10.0.4.0/24"
    "ap-south-1c" = "10.0.5.0/24"
  }
}

variable "image_id" {
  default = "ami-0a0f1259dd1c90938"
}

variable "instance_type" {
  default = "t3.large"
}
