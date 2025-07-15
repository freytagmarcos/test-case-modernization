module "networking" {
  source           = "./networking"
  vpc_cidr         = "10.0.0.0/16"
  private_sn_count = 3
  public_sn_count  = 2
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet("10.0.0.0/16", 8, i)]
  access_ip        = var.sg_access_ip
  security_groups  = local.security_groups
}

module "eks" {
  source       = "./eks"
  cluster_name = var.cluster_name
  subnet_ids   = module.networking.private_subnets
  access_cidr  = [var.sg_access_ip, var.agent_ip]
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = ["arn:aws:iam::114368227931:user/usr_terraform","arn:aws:iam::114368227931:user/Marcos-Freytag"]
}