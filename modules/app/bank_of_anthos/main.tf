resource "helm_release" "bank_of_anthos" {
  name    = "bank-of-anthos"
  chart   = "${path.module}/helm_chart"
  set {
    name = "ENV_PLATFORM"
    value = "local"
  }
  timeout = 600
}
