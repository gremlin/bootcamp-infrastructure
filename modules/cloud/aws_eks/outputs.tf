output "eks_cluster_name" {
    value = aws_eks_cluster.this.name
}

output "eks_public_security_group" {
    value = aws_security_group.global_http_access.id
}