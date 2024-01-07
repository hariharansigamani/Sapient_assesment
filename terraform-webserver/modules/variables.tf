variable "provider_role" {}
variable "resource_owner" {}
variable "aws_region" {}
variable "aws_region_short" {}
variable "environment" {}
variable "account_id" {}

variable "project" {}
variable "purpose" {}
variable "shared_aws_account_id" {}

variable "vpc_cidr_block" {}
variable "private_subnets_cidr_map" {
  type = map(string)
}
variable "public_subnets_cidr_map" {
  type = map(string)
}

variable "image_id" {}
variable "instance_type" {}

variable "webserver_port" {
  description = "The port to use for web server"
  default     = 8080
}

variable "lb_port" {
  description = "The port the load balancer should listen on for requests."
  default     = 80
}