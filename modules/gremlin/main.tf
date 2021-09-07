resource "helm_release" "gremlin" {
  for_each = var.clusters
  provider = ${"helm.cluster-"each.key}

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
    value = "group-${each.key}"
  }
  set {
    name  = "gremlin.secret.teamID"
    value = var.team_ids[each.key]
  }
  set {
    name  = "gremlin.secret.teamSecret"
    value = var.team_secrets[each.key]
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
