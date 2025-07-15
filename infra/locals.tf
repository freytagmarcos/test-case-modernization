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

locals {
    kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.aws_eks_cluster_endpoint}
    certificate-authority-data: ${lookup(module.eks.aws_eks_cluster_ca[0], "data")}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
    user: ${var.cluster_name}
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
kind: Config
preferences: {}
users:
- name: ${var.cluster_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.cluster_name}"
        - "--region"
        - "${var.aws_region}"
KUBECONFIG
}