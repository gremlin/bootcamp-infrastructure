
# Render the YAML files for values.yaml to override annotations that are 
# k8s provider specific.
locals {
  platform_values_files = {
    aws_eks = templatefile(
      "${path.module}/files/aws_eks_values.yaml.tpl",
      {
        security_group_list = join(",",var.aws_eks_security_groups),
        group_id = var.group_id
      }
    )
    digitalocean = templatefile(
      "${path.module}/files/digitalocean_values.yaml.tpl",
      {
        group_id = var.group_id
      }
    )
  }
}

resource "helm_release" "boutique_shop" {
  name    = "boutique-shop"
  chart   = "${path.module}/helm_chart"

  values = [
    local.platform_values_files[var.k8s_platform]
  ]

  set {
    name = "ENV_PLATFORM"
    value = "local"
  }

  timeout = 900
}
