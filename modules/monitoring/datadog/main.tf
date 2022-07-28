terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

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
