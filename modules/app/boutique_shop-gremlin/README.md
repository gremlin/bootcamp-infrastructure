# Google Cloud Platform Microservices Demo (modified)

This is a modified version of the [Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo) (aka Hipster Shop, Online Boutique) into a Helm Chart with resource requests and limits removed. This change was made in order to allow the application to run on smaller instances. Note that this can have negative effects on Gremlin's ability to perform attacks (some attacks will fail when resources are exhausted).

## Development

To update the Helm chart:

1. Copy the Microservice Demo's [`release/kubernetes-manifests.yaml`](https://github.com/GoogleCloudPlatform/microservices-demo/blob/master/release/kubernetes-manifests.yaml) into this module as `helm_chart/templates/boutique-shop.yaml`.
1. Remove the resource requests and limits from the YAML manifest.
1. Update the `helm_chart/Chart.yaml` to set the `appVersion` to the published version of the Microservices Demo.
