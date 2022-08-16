# Gremlin Bootcamp infrastructure

The Terraform files here will help you build a Kubernetes cluster and install Gremlin, a demo application and monitoring. The Gremlin team uses this to build infrastructure for our Chaos Engineering bootcamps.

## Using the repo

### Requirements

In order to use this repository you'll need:

* An account for a cloud hosting provider. See the [`modules/cloud` directory](https://github.com/gremlin/bootcamp-infrastructure/tree/main/modules/cloud) to see which providers are supported.
* An account for a monitoring provider. See the [`modules/monitoring` directory](https://github.com/gremlin/bootcamp-infrastructure/tree/main/modules/monitoring) to see which providers are supported.
* A Gremlin account. If you don't have a Gremlin account, you can [create one for free](https://gremlin.com/free).

You'll also need Terraform and kubectl (the Kubernetes command-line tool). For more information see:

* [How to install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [How to install kubectl](https://kubernetes.io/docs/tasks/tools/)

### Creating your cluster

1. Use your method of choice to pass in variables for the k8s_provider, demo_app and monitoring_provider that you will be using for the environment. Currently only one of each is supported per configuration.
1. Run `terraform init` to install the Terraform Providers that will be required.
1. Run `terraform apply` to begin creating the cluster, related applications and services. Terraform will prompt you for information and credentials that are required for the build.

### Gremlin credentials

Terraform will ask you for ask for Gremlin team IDs and secrets as a JSON object. This makes it easier to store a single blob in a secure store and pass the group identifier to Terraform.

The `gremlin_teams` JSON object should take the form:

```json
{
  "my_group": {
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "secret": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  },
  "your_group": {
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "secret": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  },
}
```

Note that the keys for this object are arbitrary strings (no special characters) and for Gremlin bootcamps we simply use "01", "02", "03", etc. ID and secret can be retrieved from your Gremlin account under the `Team Settings > Configuration` section.

Using the Gremlin credentials JSON object above, you can then run Terraform:

```sh
# Using a simple text file as an example. This isn't secure.
export TF_VAR_gremlin_teams=`cat gremlin_teams.txt`

# Or you could use a secure secret store like Hashicorp Vault.
export TF_VAR_gremlin_teams=$(vaut kv get secret/gremlin_teams)

# Then run Terraform and specify the group id.
# This part is easily scripted into a loop to create multiple sets of infrastructure.
terraform apply -var "group_id=my_group"
```


## Development

More info needed here.

## Common Problems
### (Digital Ocean) Error: Kubernetes cluster unreachable: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable
This occurs when terraform is polling for state upgrades, but it's trying to use an old k8s config. This happens if the k8s cluster is upgraded by DO or can happen if a droplet is migrated.
Try: `terraform plan -target module.digitalocean.digitalocean_kubernetes_cluster.k8s_cluster -target data.digitalocean_kubernetes_cluster.k8s_cluster -out my_plan`, followed by running `terraform apply my_plan`. This will update the state for the kubernetes cluster, and subsequest plan executions should work fine.
