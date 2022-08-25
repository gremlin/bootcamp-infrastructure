annotations:
  service.beta.kubernetes.io/aws-load-balancer-name: "group-${group_id}-eks-cluster-lb"
  service.beta.kubernetes.io/aws-load-balancer-extra-security-groups: "sg-0a30fa947d19d67d1"
  service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "bootcamp-group-id=group-${group_id},Name=group-${group_id}-eks-cluster-lb"
