# Install the Datadog dashboard.
terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "helm" {
  kubernetes {
    host = var.helm_host
    token = var.helm_token
    cluster_ca_certificate = var.helm_cluster_ca_certificate
  }
}

resource "helm_release" "bank_of_anthos" {
  name    = "bank-of-anthos"
  chart   = "${path.module}/helm_chart"
  set {
    name = "ENV_PLATFORM"
    value = "local"
  }
  timeout = 600
}
