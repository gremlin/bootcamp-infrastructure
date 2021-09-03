# Variables

variable "num_clusters" {
  type = number
  description = "The number of bootcamp clusters to create."
}

/*
variable "gremlin_team_id" {
  type = string
  description = "The Gremlin team ID. See https://app.gremlin.com/settings/teams to get your team ID."

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.gremlin_team_id))
    error_message = "Your Gremlin team ID must be a valid ID."
  }
}

variable "gremlin_team_secret" {
  type = string
  description = "The Gremlin team secret for the group. See https://app.gremlin.com/settings/teams to get your team secret."
  sensitive = true

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.gremlin_team_secret))
    error_message = "Your Gremlin team secret must be a valid secret."
  }
}
*/