# DigitalOcean
// output "cluster_endpoint" {
//   value = digitalocean_kubernetes_cluster.k8s_cluster.endpoint
// }

// output "cluster_token" {
//   value = digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].token
// }

// output "cluster_certificate" {
//   value = digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].cluster_ca_certificate
// }

# Set the value for the container runtime driver that Gremlin should use.
// output "container_runtime" {
//   value = "containerd-runc"
//   #value = "crio-runc"
//   #value = "docker-runc"
// }


# AWS
output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.aws_eks.cluster_endpoint
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}

output "cluster_certificate" {
  value = module.aws.cluster_certificate_authority_data
}
