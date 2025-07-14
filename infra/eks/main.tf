resource "aws_eks_cluster" "cluster_eks" {
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
  name = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version = "1.33"
  access_config {
    authentication_mode = "API"
  }
  
  encryption_config {
    provider {
      key_arn = var.kms_arn
    }
    resources = "secrets"
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
  capacity_type = ""
  instance_types = [ "t4.medium" ]
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