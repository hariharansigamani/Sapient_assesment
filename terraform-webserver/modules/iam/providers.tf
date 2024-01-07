terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {
  alias  = "aws_ap_south_1"
  region = "ap-south-1"

  assume_role {
    role_arn = var.provider_role
  }
}
