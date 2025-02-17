data "aws_availability_zones" "available" {
  state = "available"
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

locals {
  azs = data.aws_availability_zones.available.names
}

# -------------------------------------
# VPC
# -------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name   = "${var.project_name}-${var.environment}-vpc"
    PJName = var.project_name
  }
}

# -------------------------------------
# Internet Gateway
# -------------------------------------
resource "aws_internet_gateway" "igw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.project_name}-${var.environment}-igw"
    PJName = var.project_name
  }
}

# -------------------------------------
# Subnet
# -------------------------------------
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.azs, index(keys(var.public_subnets), each.key))
  map_public_ip_on_launch = false

  tags = {
    Name   = "${var.project_name}-${var.environment}-Public-Subnet-${each.key}"
    PJName = var.project_name
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.azs, index(keys(var.private_subnets), each.key))
  map_public_ip_on_launch = false

  tags = {
    Name   = "${var.project_name}-${var.environment}-Private-Subnet-${each.key}"
    PJName = var.project_name
  }
}

resource "aws_subnet" "rdsprivate_subnets" {
  for_each = var.rdsprivate_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = element(local.azs, index(keys(var.rdsprivate_subnets), each.key))
  map_public_ip_on_launch = false

  tags = {
    Name   = "${var.project_name}-${var.environment}-RDSPrivate-Subnet-${each.key}"
    PJName = var.project_name
  }
}

# -------------------------------------
# Route Table
# -------------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.project_name}-${var.environment}-Public-rtb"
    PJName = var.project_name
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.project_name}-${var.environment}-Private-rtb"
    PJName = var.project_name
  }
}

resource "aws_route_table" "rdsprivate_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.project_name}-${var.environment}-RDSPrivate-rtb"
    PJName = var.project_name
  }
}

# -------------------------------------
# Routing
# -------------------------------------
resource "aws_route" "public_subnet_to_internet" {
  count                  = var.create_internet_gateway ? 1 : 0
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route" "private_subnet_to_internet" {
  count                  = var.create_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private[0].id
}

# -------------------------------------
# RouteTable Associate
# -------------------------------------
resource "aws_route_table_association" "public_subnet_associations" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_associations" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rdsprivate_subnet_associations" {
  for_each       = aws_subnet.rdsprivate_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rdsprivate_route_table.id
}

# -------------------------------------
# NAT Gateway
# -------------------------------------
resource "aws_eip" "ngwip" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name   = "${var.project_name}-${var.environment}-ngw-eip"
    PJName = var.project_name
  }
}

resource "aws_nat_gateway" "private" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.ngwip[0].id
  subnet_id     = aws_subnet.public_subnets[keys(aws_subnet.public_subnets)[0]].id
  depends_on    = [aws_eip.ngwip]

  tags = {
    Name   = "${var.project_name}-${var.environment}-ngw"
    PJName = var.project_name
  }
}

# -------------------------------------
# S3 VPC Endpoint
# -------------------------------------
resource "aws_vpc_endpoint" "s3" {
  count           = var.create_s3_endpoint ? 1 : 0
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_route_table.public_route_table.id]

  tags = {
    Name   = "${var.project_name}-${var.environment}-S3Endpoint"
    PJName = var.project_name
  }
}
