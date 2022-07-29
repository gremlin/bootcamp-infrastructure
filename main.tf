###
# Cloud providers / Infrastructure
# Uncomment the cloud provider that you want to use.
###

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.digitalocean_token
}

# DigitalOcean
variable "digitalocean_token" {
  type = string
  description = "Your DigitalOcean API token. See https://cloud.digitalocean.com/account/api/tokens to generate a token."
}

data "digitalocean_kubernetes_versions" "version" {
  version_prefix = "1.21."
}

locals {
  node_size_by_app = {
    bank_of_anthos = "s-2vcpu-4gb",
    boutique_shop = "s-1vcpu-2gb"
  }
}

module "digitalocean" {
  count = var.k8s_platform == "digitalocean" ? 1 : 0
  source = "./modules/cloud/digitalocean"

  # Pass variables
  group_id = var.group_id
  token = var.digitalocean_token
  k8s_version = data.digitalocean_kubernetes_versions.version.latest_version
  node_size = local.node_size_by_app[var.demo_app]
}


# AWS EKS
/*
EKS specific variables and the EKS module call will go here.
*/

# Azure AKS
/*
AKS specific variables and the AKS module call will go here.
*/

# Google GKS
/*
GKS specific variables and the GKS module call will go here.
*/


###
# Helm setup and Gremlin Installation
###

# Setup the Helm Provider here so that subsequent modules don't need to reinstantiate it.
data "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name = "group-${var.group_id}"

  depends_on = [
    module.digitalocean[0]
  ]
}

// TODO: If we add a different provider, we'll need to perform logic in order to
  // properly populate the k8s config for helm based on the appropriate module source.
  // I THINK we can make this work with lookup. Otherwise it's gonna be ugly.

# Setup the Helm Provider here so that subsequent modules don't need to reinstantiate it.
provider "helm" {
  kubernetes {
    host = data.digitalocean_kubernetes_cluster.k8s_cluster.endpoint
    token = data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].cluster_ca_certificate)
  }
}

# Gremlin
module "gremlin" {
  source = "./modules/gremlin"

  # Pass variables
  group_id = var.group_id
  team_id = var.gremlin_teams[var.group_id].id
  team_secret = var.gremlin_teams[var.group_id].secret
  container_runtime = module.digitalocean[0].container_runtime
}


###
# Demo application
# Uncomment the demo application that you want to use.
###

module "boutique_shop" {
  count = var.demo_app == "boutique_shop" ? 1 : 0
  source = "./modules/app/boutique_shop-gremlin"
}

module "bank_of_anthos" {
  count = var.demo_app == "bank_of_anthos" ? 1 : 0
  source = "./modules/app/bank_of_anthos"
}


###
# Monitoring and Observability
# Uncommment the monitoring provider that you want to use.
###

# Prometheus and Grafana
/*
module "monitoring" {
  source = "./modules/monitoring/prometheus_grafana"

  # Pass variables
  group_id = var.group_id
  app = module.app.app
  ip = module.cloud.loadbalancer_ip
}
*/


# Datadog
variable "datadog_api_key" {
  type        = string
  description = "The Datadog API Key. See https://app.datadoghq.com/account/settings#api to get or create an API Key."
}
variable "datadog_app_key" {
  type        = string
  description = "The Datadog Application Key. See https://app.datadoghq.com/account/settings#api to get or create an Application Key."
}

# Configure the Datadog provider
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

module "datadog" {
  count = var.monitoring_platform == "datadog" ? 1 : 0
  source = "./modules/monitoring/datadog"

  # Pass variables
  group_id = var.group_id
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  app = var.demo_app
}


# New Relic
/*
New Relic specific variables and the New Relic module call will go here.
*/

# Dynatrace
/*
Dynatrace specific variables and the Dynatrace module call will go here.
*/
