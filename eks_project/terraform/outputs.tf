output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id //cluster name 
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint // cluster endpoint URL 
}