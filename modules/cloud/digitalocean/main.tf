terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.token
}

# This has to come before the cluster creation
resource "digitalocean_certificate" "cert" {
  count = var.num_clusters
  name = "cert-${count.index + 1}"
  type = "lets_encrypt"
  domains = ["group-${count.index + 1}.gremlinbootcamp.com"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  count = var.num_clusters
  name  = "group-${count.index + 1}"
  region = "sfo2"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.k8s_version

  node_pool {
    name = "group-${count.index + 1}"
    size = var.node_size
    node_count = var.cluster_size
    auto_scale = true
    min_nodes = var.cluster_size
    max_nodes = var.cluster_max
    tags = ["group-${count.index + 1}"]

  }
}

resource "digitalocean_loadbalancer" "public" {
  count = var.num_clusters
  name = "group-${count.index + 1}"
  region = "sfo2"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "tcp"
    target_port = 30001
    target_protocol = "tcp"
    certificate_name = digitalocean_certificate.cert[count.index].name
  }

  forwarding_rule {
    entry_port = 443 
    entry_protocol = "https"
    target_port = 30001
    target_protocol = "http"
    certificate_name = digitalocean_certificate.cert[count.index].name
  }

  healthcheck {
    port = 30001
    protocol = "tcp"
  }

  # Matches against tag set in k8s_cluster node_pool to apply to cluster nodes.
  droplet_tag = "group-${count.index + 1}"
}

resource "digitalocean_record" "subdomain" {
  count = var.num_clusters
  domain = var.domain
  type = "A"
  name = "group-${count.index + 1}"
  value = digitalocean_loadbalancer.public[count.index].ip
}