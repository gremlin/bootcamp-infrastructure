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

1. Edit the [`main.tf file`](https://github.com/gremlin/bootcamp-infrastructure/blob/main/main.tf) in the root directory of this project. Uncomment the cloud provider, demo app, and monitoring provider that you want to use (or comment out any that you do not want to use).
1. Run `terraform init` to install the Terraform Providers that will be required.
1. Run `terraform apply` to begin creating the cluster, related applications and services. Terraform will prompt you for information and credentials that are required for the build (e.g. Gremlin Team ID and Team Secret).


## Development

More info needed here.
