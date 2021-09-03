/*
Info that you'll need to connect to each cluster later will be in:
digitalocean_kubernetes_cluster.k8s_cluster[count.index].endpoint
digitalocean_kubernetes_cluster.k8s_cluster[count.index].kube_config[0].token
digitalocean_kubernetes_cluster.k8s_cluster[count.index].kube_config[0].cluster_ca_certificate
*/

# Set the value for the container runtime driver that Gremlin should use.
output "container_runtime" {
  value = "containerd-runc"
  #value = "crio-runc"
  #value = "docker-runc"
}

output "clusters" {
  value = digitalocean_kubernetes_cluster.k8s_cluster
}