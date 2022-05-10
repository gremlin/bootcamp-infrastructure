locals {
  placeholders = {
    "admin_password" = var.admin_password,
    "group_id" = var.group_id
  }
  helm_values = templatefile("${path.module}/${var.app}/values.yaml", "${local.placeholders}")
}


# Install Prometheus using the helm chart
resource "helm_release" "prometheus_helm" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [ "${local.helm_values}" ]
}

provider "grafana" {
  url = "http://group${var.group_id}.gremlinbootcamp.com:81"
  auth = "admin:${var.admin_password}"
}
