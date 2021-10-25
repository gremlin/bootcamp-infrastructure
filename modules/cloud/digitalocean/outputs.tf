output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_cluster.endpoint
}

output "cluster_token" {
  value = digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].token
}

output "cluster_certificate" {
  value = digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].cluster_ca_certificate
}

# Set the value for the container runtime driver that Gremlin should use.
output "container_runtime" {
  value = "containerd-runc"
  #value = "crio-runc"
  #value = "docker-runc"
}
