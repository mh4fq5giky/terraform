module "vpc" {
  source = "../../modules/vpc"

  PJPrefix = "testtest"
  environment  = "dev"
  aws_region   = "ap-northeast-1"
  vpc_cidr     = "10.50.0.0/16"


  public_subnets = {
    subnet1 = { cidr = "10.50.30.0/24" }
    subnet2 = { cidr = "10.50.31.0/24" }
  }

  private_subnets = {
    subnet1 = { cidr = "10.50.40.0/24" }
    subnet2 = { cidr = "10.50.41.0/24" }
  }

  rdsprivate_subnets = {
    subnet1 = { cidr = "10.50.50.0/24" }
    subnet2 = { cidr = "10.50.51.0/24" }
    subnet3 = { cidr = "10.50.52.0/24" }
  }

  create_internet_gateway = true
  create_nat_gateway      = false
  create_s3_endpoint      = false
}
