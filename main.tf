###
# Cloud providers / Infrastructure
# Uncomment the cloud provider that you want to use.
###

# DigitalOcean
variable "digitalocean_token" {
  type = string
  description = "Your DigitalOcean API token. See https://cloud.digitalocean.com/account/api/tokens to generate a token."
}
module "cloud" {
  source = "./modules/cloud/digitalocean"

  # Pass variables
  token = var.digitalocean_token 
  num_clusters = var.num_clusters
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
/*
# Setup the Helm Provider here so that subsequent modules don't need to reinstantiate it.
provider "helm" {
  kubernetes {
    host = module.cloud.cluster_endpoint
    token = module.cloud.cluster_token
    cluster_ca_certificate = base64decode(module.cloud.cluster_certificate)
  }
}
*/

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "helm" {
  alias = "cluster-1"
  kubernetes {
    host = try(module.cloud.clusters[0].endpoint, "")
    token = try(module.cloud.clusters[0].kube_config[0].token, "")
    cluster_ca_certificate = try(module.cloud.clusters[0].kube_config[0].cluster_ca_certificate, "")
  }
}

provider "helm" {
  alias = "cluster-2"
  kubernetes {
    host = try(module.cloud.clusters[1].endpoint, "")
    token = try(module.cloud.clusters[1].kube_config[0].token, "")
    cluster_ca_certificate = try(module.cloud.clusters[1].kube_config[0].cluster_ca_certificate, "")
  }
}

provider "helm" {
  alias = "cluster-3"
  kubernetes {
    host = try(module.cloud.clusters[2].endpoint, "")
    token = try(module.cloud.clusters[2].kube_config[0].token, "")
    cluster_ca_certificate = try(module.cloud.clusters[2].kube_config[0].cluster_ca_certificate, "")
  }
}

provider "helm" {
  alias = "cluster-4"
  kubernetes {
    host = try(module.cloud.clusters[3].endpoint, "")
    token = try(module.cloud.clusters[3].kube_config[0].token, "")
    cluster_ca_certificate = try(module.cloud.clusters[3].kube_config[0].cluster_ca_certificate, "")
  }
}

provider "helm" {
  alias = "cluster-5"
  kubernetes {
    host = try(module.cloud.clusters[4].endpoint, "")
    token = try(module.cloud.clusters[4].kube_config[0].token, "")
    cluster_ca_certificate = try(module.cloud.clusters[4].kube_config[0].cluster_ca_certificate, "")
  }
}

# Gremlin
module "gremlin" {
  source = "./modules/gremlin"
    
  # Pass variables
  #num_clusters = length(module.cloud.clusters)
  clusters = module.cloud.clusters
  container_runtime = module.cloud.container_runtime
  team_ids = var.gremlin_team_ids
  team_secrets = var.gremlin_team_secrets
}


###
# Demo application
# Uncomment the demo application that you want to use.
###

/*
# Boutique Shop - Gremlin
# This is a modified version of the Google Microservices Demo at https://github.com/GoogleCloudPlatform/microservices-demo
module "app" {
  source = "./modules/app/boutique_shop-gremlin"
}
*/

# Boutique Shop
/*
Standard Boutique Shop install.
*/

# Bank of Anthos
/*
Bank of Anthos install.
*/


###
# Monitoring and Observability
# Uncommment the monitoring provider that you want to use.
###

/*
# Datadog
variable "datadog_api_key" {
  type        = string
  description = "The Datadog API Key. See https://app.datadoghq.com/account/settings#api to get or create an API Key."
}
variable "datadog_app_key" {
  type        = string
  description = "The Datadog Application Key. See https://app.datadoghq.com/account/settings#api to get or create an Application Key."
}
module "monitoring" {
  source = "./modules/monitoring/datadog"
    
  # Pass variables
  group_id = var.group_id
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
*/

# New Relic
/*
New Relic specific variables and the New Relic module call will go here.
*/

# Dynatrace
/*
Dynatrace specific variables and the Dynatrace module call will go here.
*/
