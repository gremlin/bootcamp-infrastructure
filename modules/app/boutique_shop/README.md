# Google Cloud Platform Microservices Demo

This is a straight "conversion" of the [Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo) (aka Hipster Shop, Online Boutique) into a Helm Chart.

## Development

To update the Helm chart:

1. Copy the Microservice Demo's [`release/kubernetes-manifests.yaml`](https://github.com/GoogleCloudPlatform/microservices-demo/blob/master/release/kubernetes-manifests.yaml) into this module's `helm_chart/templates/` directory.
1. Update the `helm_chart/Chart.yaml` to set the `appVersion` to the published version of the Microservices Demo.
