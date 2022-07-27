# Install the Datadog Agent using the helm chart
resource "helm_release" "datadog_helm" {
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"

  values = [
    "${file("${path.module}/${var.app}/values.yaml")}"
  ]

  set {
    name  = "datadog.apiKey"
    value = var.api_key
  }

  set {
    name  = "datadog.tags"
    value = "{group:${var.group_id}, cluster:group-${var.group_id}}"
  }
}

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

# Configure the Datadog provider
provider "datadog" {
  api_key = var.api_key
  app_key = var.app_key
}

provider "helm" {
  kubernetes {
    host = var.helm_host
    token = var.helm_token
    cluster_ca_certificate = var.helm_cluster_ca_certificate
  }
}

# Get the "Bootcamps" dashboard list
data "datadog_dashboard_list" "bootcamps_list" {
  name = "Bootcamps"
}

# Get the correct app dashboard
data "local_file" "dashboard" {
  filename = "${path.module}/${var.app}/dashboard.json"
}

# Create the dashboard.
resource "datadog_dashboard_json" "dashboard_json" {
  dashboard_lists = ["${data.datadog_dashboard_list.bootcamps_list.id}"]
  dashboard = replace(file("${path.module}/${var.app}/dashboard.json"), "[[GROUP_ID]]", var.group_id)
}
