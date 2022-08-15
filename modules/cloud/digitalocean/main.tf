terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


# This has to come before the cluster creation
resource "digitalocean_certificate" "cert" {
  count = var.ssl ? 1 : 0
  name = "cert-${var.group_id}"
  type = "lets_encrypt"
  domains = ["group${var.group_id}.gremlinbootcamp.com"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name  = "group-${var.group_id}"
  region = "sfo2"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.k8s_version

  node_pool {
    name = "group-${var.group_id}"
    size = var.node_size
    auto_scale = true
    min_nodes = var.cluster_size
    max_nodes = var.cluster_max
    tags = ["group-${var.group_id}"]
  }

}

resource "digitalocean_loadbalancer" "public" {
  name = "group-${var.group_id}"
  region = "sfo2"

  # Forward std web traffic to the demo ap
  forwarding_rule {
    entry_port = 80
    entry_protocol = "tcp"
    target_port = 30080
    target_protocol = "tcp"
  }

  # Forward port 8080 to Grafana
  # If you're not using Grafana for monitoring, this will just point nowhere
  forwarding_rule {
    entry_port = 81
    entry_protocol = "tcp"
    target_port = 30081
    target_protocol = "tcp"
  }

  # Setup HTTPS/TLS if enabled
  dynamic "forwarding_rule" {
    for_each = var.ssl ? [1] : []
      content {
      entry_port = 443
      entry_protocol = "https"
      target_port = 30080
      target_protocol = "http"
      certificate_name = digitalocean_certificate.cert[0].name
    }
  }

  healthcheck {
    port = 30080
    protocol = "tcp"
  }

  # Matches against tag set in k8s_cluster node_pool to apply to cluster nodes.
  droplet_tag = "group-${var.group_id}"
}

resource "digitalocean_record" "subdomain" {
  domain = var.domain
  type = "A"
  name = "group${var.group_id}"
  value = digitalocean_loadbalancer.public.ip
}
