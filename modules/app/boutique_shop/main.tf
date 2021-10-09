resource "helm_release" "boutique_shop" {
  name    = "boutique_shop"
  chart   = "${path.module}/helm_chart"
  set {
    name = "ENV_PLATFORM"
    value = "local"
  }
  timeout = 600
}
