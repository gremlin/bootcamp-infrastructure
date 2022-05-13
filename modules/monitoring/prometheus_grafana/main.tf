locals {
  placeholders = {
    "admin_password" = var.admin_password,
    "group_id" = var.group_id
  }
  helm_values = templatefile("${path.module}/${var.app}/values.yaml", "${local.placeholders}")
}


# Install Prometheus using the helm chart
resource "helm_release" "prometheus_helm" {
  name = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  namespace = "monitoring"
  create_namespace = true

  values = [ "${local.helm_values}" ]
}

# Install the Grafana dashboards.
terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
  }
}

provider "grafana" {
  url = "http://${var.ip}:81"
  auth = "admin:${var.admin_password}"
}

resource "grafana_dashboard" "dashboard" {
  config_json = file("${path.module}/${var.app}/dashboard.json")
  overwrite = true
}
