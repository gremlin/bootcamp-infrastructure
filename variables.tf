###################
# Gremlin Variables
###################
variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.group_id))
    error_message = "Enter a valid group id number. Tip: it doesnt strictly need to be a number (e.g. you could create a group named 00-yourname), but it must only contain letters, numbers, underscores and dashes."
  }
}

variable "gremlin_teams" {
  type = map(
    object({
      id = string
      secret = string
    })
  )
  description = "A map of group objects containing the coresponding Gremlin team id and secret. This must include the value provided for var.group_id"
}


###########################
# Platform Option Variables
###########################
variable "k8s_platform" {
  type = string
  validation {
    condition = contains(["digitalocean","aws_eks"],var.k8s_platform)
    error_message = "Invalid monitoring platform selected. Valid options are: digitalocean."
  }
}

variable "monitoring_platform" {
  type = string
  validation {
    condition = contains(["datadog"],var.monitoring_platform)
    error_message = "Invalid monitoring platform selected. Valid options are: datadog."
  }
}

variable "demo_app" {
  type = string
  validation {
    condition = contains(["boutique_shop","bank_of_anthos"],var.demo_app)
    error_message = "Invalid demo app selected. Valid options are: boutique_shop, bank_of_anthos."
  }
}

variable "dns_platform" {
  type = string
  default = ""
  description = "DNS Platform for the bootcamp. If left unset, this is not managed."
  validation {
    condition = contains(["digitalocean",""],var.dns_platform)
    error_message = "Invalid dns platform provided. Valid options are: digitalocean."
  }
}


############################################
# DigitalOcean Kubernetes Platform Variables
############################################
variable "digitalocean_droplet_slug" {
  type = string
  default = ""
  description = "Provide this to override the default droplet sizes (CPU + memory) used in DigitalOcean"
}


#######################################
# AWS EKS Kubernetes Platform Variables
#######################################
variable "eks_vpc_id" {
  type = string
  description = "Existing VPC ID for provisioning EKS cluster."
}

variable "eks_public_subnet_ids" {
  type = list(string)
  description = "List of subnet IDs inside the selected VPC where we will provision EKS EC2 resources. By default, all subnets in the VPC will be used."
}

variable "eks_private_subnet_ids" {
  type = list(string)
  description = "List of subnet IDs inside the selected VPC where we will provision EKS EC2 resources. By default, all subnets in the VPC will be used."
}

variable "eks_public_access_cidrs" {
  type = list(string)
  default = ["0.0.0.0/0"]
  description = "Optional list of CIDRs which should have access to the EKS cluster. By default, access to the cluster it not restricted."
}

variable "eks_security_group_ids" {
  type = list(string)
  default = ["0.0.0.0/0"]
  description = "Optional list of VPC Security Group IDs which will be used to limit access to the Kubernetes API endpoint. If not provided, access to the Kubernetes APIs is not restricted."
}

variable "eks_instance_types" {
  type = list(string)
  default = ["t3.medium","t3a.medium"]
  description = "Optional list of EC2 instance types to use for the EKS cluster."
}