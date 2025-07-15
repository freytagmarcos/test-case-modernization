resource "aws_eks_cluster" "cluster_eks" {
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
  name = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version = "1.33"
  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    endpoint_public_access = true
    subnet_ids = var.subnet_ids
    public_access_cidrs = var.access_cidr
  }
}

resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_node_group" "eks_node_group" {
  node_group_name = "${var.cluster_name}-node_group"
  cluster_name = aws_eks_cluster.cluster_eks.name
  subnet_ids = var.subnet_ids
  node_role_arn = aws_iam_role.eks_node_group_role.arn
  capacity_type = "SPOT"
  instance_types = [ "t4g.medium" ]
  ami_type = "AL2023_ARM_64_STANDARD"
  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "${var.cluster_name}-node_group_role"
    assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_access_entry" "eks_access" {
  cluster_name = aws_eks_cluster.cluster_eks.name
  principal_arn = var.principal_arn
  kubernetes_groups = ["admin"]
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_access_entry" {
  cluster_name = aws_eks_cluster.cluster_eks.name
  policy_arn = var.policy_arn
  principal_arn = var.principal_arn
  access_scope {
    type = "cluster"
  }
  
}