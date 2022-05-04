# Install Prometheus using the helm chart
resource "helm_release" "prometheus_helm" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-community/kube-prometheus-stack"

  values = [
    "${replace(file("${path.module}/${var.app}/values.yaml"), "[[GROUP_ID]]", "${var.group_id}")}"
  ]

}

