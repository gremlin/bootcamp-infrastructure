###
# Cloud providers / Infrastructure
# Uncomment the cloud provider that you want to use.
###

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.26.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


#######################
# DigitalOcean Provider
#######################

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

  node_size = coalesce(
    var.digitalocean_droplet_slug,
    local.node_size_by_app[var.demo_app]
  )
}

module "digitalocean" {
  count = var.k8s_platform == "digitalocean" ? 1 : 0
  source = "./modules/cloud/digitalocean"

  # Pass variables
  group_id = var.group_id
  token = var.digitalocean_token
  k8s_version = data.digitalocean_kubernetes_versions.version.latest_version
  node_size = local.node_size
}


##############
# AWS Provider
##############

provider "aws" {
  # Pass configuration via environment variables
}

module "aws_eks" {
  count = var.k8s_platform == "aws_eks" ? 1 : 0
  source = "./modules/cloud/aws_eks"

  group_id = var.group_id
  vpc_id = var.eks_vpc_id
  private_subnet_ids = var.eks_private_subnet_ids
  public_subnet_ids = var.eks_public_subnet_ids
  public_access_cidrs = var.eks_public_access_cidrs
  eks_security_group_ids = var.eks_security_group_ids
  eks_instance_types = var.eks_instance_types
}

output "eks_cluster_identity" {
  value = module.aws_eks[0].eks_cluster_identity
}

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
  count = var.k8s_platform == "digitalocean" ? 1 : 0
  name = "group-${var.group_id}"

  depends_on = [
    module.digitalocean
  ]
}

data "aws_eks_cluster" "k8s_cluster" {
  count = var.k8s_platform == "aws_eks" ? 1 : 0
  #name = "group-${var.group_id}"
  name = module.aws_eks[0].eks_cluster_name

  depends_on = [
    module.aws_eks
  ]
}

data "aws_eks_cluster_auth" "k8s_cluster_auth" {
  count = var.k8s_platform == "aws_eks" ? 1 : 0
  #name = "group-${var.group_id}"
  name = module.aws_eks[0].eks_cluster_name

  depends_on = [
    module.aws_eks[0]
  ]
}

locals {
  helm_host = {
    digitalocean = var.k8s_platform == "digitalocean" ? data.digitalocean_kubernetes_cluster.k8s_cluster[0].endpoint : ""
    aws_eks = var.k8s_platform == "aws_eks" ? data.aws_eks_cluster.k8s_cluster[0].endpoint : ""
  }

  helm_token = {
    digitalocean = var.k8s_platform == "digitalocean" ? data.digitalocean_kubernetes_cluster.k8s_cluster[0].kube_config[0].token : ""
    aws_eks = var.k8s_platform == "aws_eks" ? data.aws_eks_cluster_auth.k8s_cluster_auth[0].token : ""
  }

  helm_cluster_ca_certificate = {
    digitalocean = var.k8s_platform == "digitalocean" ? base64decode(data.digitalocean_kubernetes_cluster.k8s_cluster[0].kube_config[0].cluster_ca_certificate) : ""
    aws_eks = var.k8s_platform == "aws_eks" ? base64decode(data.aws_eks_cluster.k8s_cluster[0].certificate_authority[0].data) : ""
  }

  helm_runtime = {
    digitalocean = var.k8s_platform == "digitalocean" ? module.digitalocean[0].container_runtime : ""
    aws_eks = var.k8s_platform == "aws_eks" ? "containerd-runc" : ""
  }

}

# Setup the Helm Provider here so that subsequent modules don't need to reinstantiate it.
provider "helm" {
  kubernetes {
    host = local.helm_host[var.k8s_platform]
    token = local.helm_token[var.k8s_platform]
    cluster_ca_certificate = local.helm_cluster_ca_certificate[var.k8s_platform]
  }
}

provider "kubernetes" {
  host = local.helm_host[var.k8s_platform]
  token = local.helm_token[var.k8s_platform]
  cluster_ca_certificate = local.helm_cluster_ca_certificate[var.k8s_platform]
}

# Gremlin
module "gremlin" {
  source = "./modules/gremlin"

  # Pass variables
  group_id = var.group_id
  team_id = var.gremlin_teams[var.group_id].id
  team_secret = var.gremlin_teams[var.group_id].secret
  container_runtime = local.helm_runtime[var.k8s_platform]
}


###
# Demo application
# Uncomment the demo application that you want to use.
###

module "boutique_shop" {
  count = var.demo_app == "boutique_shop" ? 1 : 0
  source = "./modules/app/boutique_shop"

  group_id = var.group_id
  k8s_platform = var.k8s_platform
  aws_eks_security_groups = [
    module.aws_eks[0].eks_public_security_group
  ]
}

#data "aws_lb" "lb" {
#  count = var.k8s_platform == "aws_eks" ? 1 : 0
#
#  tags = {
#    Key = "Name"
#    Value = "group-01-eks-cluster-lb"
#  }
#  #name = "group-${var.group_id}-eks-cluster-lb"
#    #bootcamp_group_id = "group-${var.group_id}"
#  #  "kubernetes.io/cluster/group-01-eks-cluster": "owned"
#  #}
#
#  depends_on = [
#    module.boutique_shop,
#    module.bank_of_anthos
#  ]
#}


#output "helm_manifest" {
#  value = module.boutique_shop.0.helm_manifest
#}
#
#output "helm_metadata" {
#  value = module.boutique_shop.0.helm_metadata
#}

#output "dns_record" {
#  value = data.aws_lb.lb[0].dns_name
#}

data "kubernetes_service" "lb" {
  metadata {
    name = "frontend-external"
    namespace = "default"
  }
}

locals {
  dns_name = data.kubernetes_service.lb.status.0.load_balancer.0.ingress.0.hostname
}

output "elb_dns_name" {
  value = local.dns_name
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
