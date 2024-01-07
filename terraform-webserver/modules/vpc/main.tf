# Create VPC
resource "aws_vpc" "default_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s", var.common_name_prefix, "vpc")
  })
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each = length(var.public_subnets_cidr_map) > 0 ? var.public_subnets_cidr_map : {}

  vpc_id                  = aws_vpc.default_vpc.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = merge(var.common_tags_map, {
    Name = format("%s-%d", var.common_name_prefix, index(keys(var.public_subnets_cidr_map), each.key) + 1)
  })
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each = length(var.private_subnets_cidr_map) > 0 ? var.private_subnets_cidr_map : {}
  
  vpc_id                  = aws_vpc.default_vpc.id
  availability_zone       = each.key
  cidr_block              = each.value

  tags = merge(var.common_tags_map, {
    Name = format("%s-%d", var.common_name_prefix, index(keys(var.private_subnets_cidr_map), each.key) + 1)
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.default_vpc.id

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s", var.common_name_prefix, "igw")
  })
}

# Create Public Routing Table and Associate with Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s-%s", var.common_name_prefix, "public", "rt")
  })
}

resource "aws_route_table_association" "public_route_association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Private Routing Table and Associate with Private Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.default_vpc.id

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s-%s", var.common_name_prefix, "private", "rt")
  })
}

resource "aws_route_table_association" "private_route_association" {
  for_each       = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}