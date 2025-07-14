locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security group for public access"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.sg_access_ip]
        }
      }
    }
    ecs = {
      name        = "ecs_sg"
      description = "ECS Security Group"
      ingress = {
        rds = {
          from        = var.app_port
          to          = var.app_port
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
  }
}