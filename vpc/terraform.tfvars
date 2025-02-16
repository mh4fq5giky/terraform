project_name = "myproject"
environment  = "dev"
aws_region   = "ap-northeast-1"

vpc_cidr = "10.30.0.0/16"
public_subnets = {
  public1 = { cidr = "10.30.1.0/24" }
  public2 = { cidr = "10.30.2.0/24" }
}

private_subnets = {
  private1 = { cidr = "10.30.11.0/24" }
  private2 = { cidr = "10.30.12.0/24" }
}

rdsprivate_subnets = {
  rdsprivate1 = { cidr = "10.30.21.0/24" }
  rdsprivate2 = { cidr = "10.30.22.0/24" }
}

create_internet_gateway = true
create_nat_gateway      = false
create_s3_endpoint      = false
