# Variables

variable "num_clusters" {
  type = number
  description = "The number of bootcamp clusters to create."
}

variable "gremlin_team_ids" {
  type = list(string)
  description = "A list of Gremlin team IDs. See https://app.gremlin.com/settings/teams to get your team ID."
}

variable "gremlin_team_secrets" {
  type = list(string)
  description = "A list of Gremlini team secrets. See https://app.gremlin.com/settings/teams to get your team secret."
  sensitive = true
}