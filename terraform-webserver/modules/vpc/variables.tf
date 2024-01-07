variable "vpc_cidr_block" {}
variable "private_subnets_cidr_map" {
  type = map(string)
}
variable "public_subnets_cidr_map" {
  type = map(string)
}
variable "common_tags_map" {
  type = map(string)
}
variable "common_name_prefix" {}
variable "environment" {}

variable "provider_role" {}