# Bank of Anthos demo app

This is a conversion of the [Bank of Anthos](https://github.com/GoogleCloudPlatform/bank-of-anthos) demo app into a helm chart.

## Development

To update the Helm chart:

1. Copy the [`jwt-secret.yaml`](https://github.com/GoogleCloudPlatform/bank-of-anthos/blob/master/extras/jwt/jwt-secret.yaml) file into this module's `helm_chart/templates` directory.
1. Copy all the files in the [`kubernetes-manifests`](https://github.com/GoogleCloudPlatform/bank-of-anthos/tree/master/kubernetes-manifests) directory into this module's `helm_chart/templates` directory.
1. Modify the yaml files to set `ENABLE_TRACING` and `ENABLE_METRICS` both to `false`. Note, metrics and tracing will still be available to local monitoring agents, but this will prevent the app from trying to send them to a Google Cloud account.
1. Update the `helm_chart/templates/frontend.yaml` to use a NodePort instead of LoadBalancer.
1. Update the `helm_chart/Chart.yaml` to set the `appVersion` to the published version of the Microservices Demo.
