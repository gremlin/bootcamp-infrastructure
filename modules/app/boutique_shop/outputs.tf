output "app" {
  value = "boutique_shop"
}

output "helm_manifest" {
  value = helm_release.boutique_shop.manifest
}

output "helm_metadata" {
  value = helm_release.boutique_shop.metadata
}

#output "dns_record_target" {
#  value = helm_release.boutique_shop.manifest["service/v1/frontend-external"]
#}
#
#output "dns_record_type" {
#
#}