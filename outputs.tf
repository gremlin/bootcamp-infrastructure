output "k8s_host" {
    value = data.digitalocean_kubernetes_cluster.k8s_cluster.endpoint
    sensitive = false
}

output "k8s_token" {
    value = data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].token
    sensitive = true
}

output "k8s_cert" {
    value = base64decode(data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].cluster_ca_certificate)
    sensitive = true
}