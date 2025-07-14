module "networking" {
  source = "./networking"
  vpc_cidr         = "10.123.0.0/16"
  private_sn_count = 2
  public_sn_count  = 2
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet("10.123.0.0/16", 8, i)]
  access_ip        = var.sg_access_ip
  security_groups  = local.security_groups
}