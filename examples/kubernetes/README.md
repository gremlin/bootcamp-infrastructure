## Deploy the kubernetes layer.

Per guidance [here](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#stacking-with-managed-kubernetes-cluster-resources), you should not deploy a kubernetes cluster and also deploy applications onto that cluster in the same apply. Therefore, we are splitting the deployment into 2 stages:
1. Deploy the kubernetes cluster
1. Deploy applications onto the kubernetes cluster

