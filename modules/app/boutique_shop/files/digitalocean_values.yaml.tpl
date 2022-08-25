---
frontend-external:
  annotations:
    kubernetes.digitalocean.com/load-balancer-id: group-${group_id}
    service.beta.kubernetes.io/do-loadbalancer-size-unit: "1"
    service.beta.kubernetes.io/do-loadbalancer-disable-lets-encrypt-dns-records: "false"