variable "common_tags_map" {
  type = map(string)
}
variable "common_name_prefix" {}
variable "environment" {}
variable "provider_role" {}
variable "image_id" {}
variable "instance_type" {}

variable "aws_region" {}

variable "root_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, gp3 or io1."
  default     = "gp3"
}

variable "root_volume_size" {
  description = "The size, in GB, of the root EBS volume."
  default     = 100
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "data_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, gp3 or io1."
  default     = "gp3"
}

variable "data_volume_size" {
  description = "The size, in GB, of the /data EBS volume."
  default     = 100
}

variable "data_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "tenancy" {
  description = "The tenancy of the instance. Must be one of: default, dedicated or host."
  default     = "default"
}

variable "cluster_size_min" {
  description = "Min.number of nodes to have in ASG" 
  default     = 1
}

variable "cluster_size_desired" {
  description = "Max.number of nodes to have in ASG" 
  default     = 1
}

variable "cluster_size_max" {
  description = "Desired.number of nodes to have in ASG" 
  default     = 3
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default."
  default     = "Default"
}

variable "health_check_type" {
  description = "Controls how health checking is done. Must be one of EC2 or ELB."
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time, in seconds, after instance comes into service before checking health."
  default     = 300
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "enabled_metrics" {
  description = "List of autoscaling group metrics to enable."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed."
  type        = list(string)
}

variable "vpc_id" {
  description = "Set to default VPC id"
  default     = ""
}

variable "internal" {
  description = "If set to true, this will be an internal ELB, accessible only within the VPC."
  default     = false
}

variable "cross_zone_load_balancing" {
  description = "Set to true to enable cross-zone load balancing"
  default     = true
}

variable "idle_timeout" {
  description = "The time, in seconds, that the connection is allowed to be idle."
  default     = 60
}

variable "health_check_protocol" {
  description = "The protocol to use for health checks. Must be one of: HTTP, HTTPS, TCP, SSL."
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The path to use for health checks. Must return a 200 OK when the service is ready to receive requests from the ELB."
  default     = "/"
}

variable "health_check_port" {
  description = "The port to use for health checks if not vault_api_port."
  default     = 0
}

variable "health_check_interval" {
  description = "The amount of time, in seconds, between health checks."
  default     = 15
}

variable "health_check_healthy_threshold" {
  description = "The number of health checks that must pass before the instance is declared healthy."
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of health checks that must fail before the instance is declared unhealthy."
  default     = 2
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, before a health check times out."
  default     = 5
}

variable "webserver_port" {
  description = "The port to use for webserver."
}

variable "lb_port" {
  description = "The port the load balancer should listen on for requests."
}