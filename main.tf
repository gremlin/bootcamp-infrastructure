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
  group_id = var.group_id
  token = var.digitalocean_token 
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
provider "helm" {
  kubernetes {
    host = module.cloud.cluster_endpoint
    token = module.cloud.cluster_token
    cluster_ca_certificate = base64decode(module.cloud.cluster_certificate)
  }
}

# Gremlin
module "gremlin" {
  source = "./modules/gremlin"
    
  # Pass variables
  group_id = var.group_id
  team_id = var.gremlin_team_id
  team_secret = var.gremlin_team_secret
  container_runtime = module.cloud.container_runtime
}


###
# Demo application
# Uncomment the demo application that you want to use.
###

# Boutique Shop - Gremlin
# This is a modified version of the Google Microservices Demo at https://github.com/GoogleCloudPlatform/microservices-demo
# The modifications allow it to be installed on a smaller Kubernetes cluster.
module "app" {
  source = "./modules/app/boutique_shop-gremlin"
}

# Boutique Shop - Standard install
# This is the unmodified version of the Google Microservices Demo at https://github.com/GoogleCloudPlatform/microservices-demo
/*
module "app" {
  source = "./modules/app/boutique_shop"
}
*/

# Bank of Anthos - Standard install
# This is the unmodified version of the Google Bank of Anthos demo at https://github.com/GoogleCloudPlatform/bank-of-anthos
# The features to send metrics and traces to a Google Cloud account have been disabled.
/*
module "app" {
  source = "./modules/app/bank_of_anthos"
}
*/


###
# Monitoring and Observability
# Uncommment the monitoring provider that you want to use.
###

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

# New Relic
/*
New Relic specific variables and the New Relic module call will go here.
*/

# Dynatrace
/*
Dynatrace specific variables and the Dynatrace module call will go here.
*/
