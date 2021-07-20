resource "helm_release" "boutique" {
  name    = "boutique"
  chart   = "${path.module}/helm_chart"
  set {
    name = "ENV_PLATFORM"
    value = "local"
  }
  timeout = 600
}