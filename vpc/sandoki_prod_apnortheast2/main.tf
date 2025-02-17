module "vpc" {
  source = "../modules/vpc"

  project                             = "sandoki"
  env                                 = "prod"
  aws_region                          = "ap-northeast-2"
  azs                                 = ["ap-northeast-2a", "ap-northeast-2c"]
  vpc_name                            = "sandoki_prod_vpc"
  allowed_cidr_blocks_to_bastion_host = var.allowed_cidr_blocks_to_bastion_host

  vpc_cidr_block = "10.1.0.0/16"
  public_subnet_cidr_blocks = [
    "10.1.1.0/24",
    "10.1.2.0/24",
  ]
  private_subnet_cidr_blocks = [
    "10.1.51.0/24",
    "10.1.52.0/24",
  ]
  isolated_private_subnet_cidr_blocks = [
    "10.1.101.0/24",
    "10.1.102.0/24",
  ]
}
