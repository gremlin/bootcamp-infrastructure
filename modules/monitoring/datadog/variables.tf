variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."
}

variable "api_key" {
  type = string
  description = "The Datadog API Key. See https://app.datadoghq.com/account/settings#api to get or create an API Key."
  sensitive = true
}

variable "app_key" {
  type = string
  description = "The Datadog Application Key. See https://app.datadoghq.com/account/settings#api to get or create an Application Key."
  sensitive = true
}

variable "app" {
  type = string
  description = "The demo app that was deployed. This will be used to select the correct dashboard and monitoring configuration."
}
