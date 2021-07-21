resource "helm_release" "gremlin" {
  name  = "gremlin"
  chart = "gremlin/gremlin"

  set {
    name  = "gremlin.secret.managed"
    value = "true"
  }
  set {
    name  = "gremlin.secret.type"
    value = "secret"
  }
  set {
    name  = "gremlin.secret.clusterID"
    value = "group-${var.group_id}"
  }
  set {
    name  = "gremlin.secret.teamID"
    value = var.team_id
  }
  set {
    name  = "gremlin.secret.teamSecret"
    value = var.team_secret
  }
  set {
    name = "gremlin.apparmor"
    value = "unconfined"
  }
  set {
    name = "gremlin.hostPID"
    value = "true"
  }
  set {
    name = "gremlin.container.driver"
    value = var.container_runtime
  }
  set {
    name = "gremlin.collect.processes"
    value = "true"
  }
}
