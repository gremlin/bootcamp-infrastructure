variable "token" {
  type = string
  description = "Your DigitalOcean API token. See https://cloud.digitalocean.com/account/api/tokens to generate a token."

  validation {
    condition = can(regex("^\\w+$", var.token))
    error_message = "Your DigitalOcean API token must be a valid token."
  }
}

variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.group_id))
    error_message = "Enter a valid group id number. Tip: it doesnt strictly need to be a number (e.g. you could create a group named 00-yourname), but it must only contain letters, numbers, underscores and dashes."
  }
}

# Digital Ocean Cluster information.
# Defaults are set on these so they don't need to be passed unless an override is needed.

variable "cluster_size" {
  type = number
  description = "The number of nodes in the Kubernetes cluster."
  default = 3
}

variable "cluster_max" {
  type = number
  description = "The maximum number of nodes in the cluster. Autoscaling is enabled by default."
  default = 4
}

variable "node_size" {
  type = string
  description = "The node size slug. Node sizes can be retrieved with the Digital Ocean API: https://developers.digitalocean.com/documentation/v2/#sizes"
  default = "s-1vcpu-2gb"
}

  # Grab the latest version slug from `doctl kubernetes options versions`
variable "k8s_version" {
  type = string
  description = "The version of Kubernetes to use. To see available versions use the command: doctl kubernetes options versions"
  default = "1.20.8-do.0"
}

variable "domain" {
  type = string
  description = "The primary domain for the demo application. Individual group IDs will be created as subdomains."
  default = "gremlinbootcamp.com"
}