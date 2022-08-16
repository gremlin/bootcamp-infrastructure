# Google Cloud Platform Microservices Demo

This is a straight "conversion" of the [Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo) (aka Hipster Shop, Online Boutique) into a Helm Chart.

## Development

To update the Helm chart:

1. Copy the Microservice Demo's [`release/kubernetes-manifests.yaml`](https://github.com/GoogleCloudPlatform/microservices-demo/blob/master/release/kubernetes-manifests.yaml) into this module's `helm_chart/templates/` directory.
1. Update the `helm_chart/Chart.yaml` to set the `appVersion` to the published version of the Microservices Demo.
1. Remove all resource limits from the deployment templates.
1. Update the resource requests values for CPU to be 50% of the default values.
1. Change the frontend-external service to use a NodePort with a value of 30080 instead of a loadbalancer.
