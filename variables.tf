# Variables

variable "group_id" {
  type = string
  description = "The id or number of the bootcamp group."

  validation {
    condition = can(regex("^[0-9A-Za-z_-]+$", var.group_id))
    error_message = "Enter a valid group id number. Tip: it doesnt strictly need to be a number (e.g. you could create a group named 00-yourname), but it must only contain letters, numbers, underscores and dashes."
  }
}

# Load all of the Gremlin team info
variable "gremlin_teams" {
  type = map(
    object({
      id = string
      secret = string
    })
  )
  description = "A map of group objects containing the coresponding Gremlin team id and secret."
}
