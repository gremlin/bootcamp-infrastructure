variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."
}

variable "app" {
  type = string
  description = "The demo app that was deployed. This will be used to select the correct dashboard and monitoring configuration."
}

variable "ip" {
  type = string
  description = "The cluster loadbalancer's external IP address. We need this because the domain name typically will not resolve soon enough to allow access to the Grafana API."
}

variable "admin_password" {
  type = string
  description = "The admin password to log into Grafana. Note that the username is 'admin'."
  default = "Chaos!"
}
