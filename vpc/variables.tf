variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "Public subnet configurations"
  type = map(object({
    cidr = string
  }))
}

variable "private_subnets" {
  description = "Private subnet configurations"
  type = map(object({
    cidr = string
  }))
}

variable "rdsprivate_subnets" {
  description = "RDS Private subnet configurations"
  type = map(object({
    cidr = string
  }))
}

variable "create_internet_gateway" {
  description = "Whether to create a Internet Gateway"
  type        = bool
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
}

variable "create_s3_endpoint" {
  description = "Whether to create an S3 endpoint"
  type        = bool
}
