# Variables

variable "clusters" {
  type = any
  description = "The list of cluster configs."
}

variable "container_runtime" {
  type = string
  description = "The container runtime that Gremlin should use (docker-runc, crio-runc, containerd-runc)."
}

variable "team_ids" {
  type = list(string)
  description = "A list of Gremlin team IDs. See https://app.gremlin.com/settings/teams to get your team ID."
}

variable "team_secrets" {
  type = list(string)
  description = "A list of Gremlini team secrets. See https://app.gremlin.com/settings/teams to get your team secret."
  sensitive = true
}