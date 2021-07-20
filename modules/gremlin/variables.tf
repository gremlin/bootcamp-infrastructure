# Variables

variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.group_id))
    error_message = "Enter a valid group id number. Tip: it doesnt strictly need to be a number (e.g. you could create a group named 00-yourname), but it must only contain letters, numbers, underscores and dashes."
  }
}

variable "team_id" {
  type        = string
  description = "The Gremlin team ID. See https://app.gremlin.com/settings/teams to get your team ID."

  validation {
    condition     = can(regex("^[0-9A-Za-z_-]+$", var.team_id))
    error_message = "Your Gremlin team ID must be a valid ID."
  }
}

variable "team_secret" {
  type        = string
  description = "The Gremlin team secret for the group. See https://app.gremlin.com/settings/teams to get your team secret."

  validation {
    condition     = can(regex("^[0-9A-Za-z_-]+$", var.team_secret))
    error_message = "Your Gremlin team secret must be a valid secret."
  }
}