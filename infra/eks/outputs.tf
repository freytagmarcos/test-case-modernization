output "aws_eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster_eks.endpoint
}

output "aws_eks_cluster_ca" {
  value = aws_eks_cluster.cluster_eks.certificate_authority
}

output "aws_eks_cluster_id" {
  value = aws_eks_cluster.cluster_eks.id
}

output "aws_eks_cluster" {
  value = aws_eks_cluster.cluster_eks.access_config
}