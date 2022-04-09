

### Requirements

In order to use this repository you'll need kubectl (the Kubernetes command-line tool), and aws-cli (the AWS command-line tool). For more information see:

* [How to install kubectl](https://kubernetes.io/docs/tasks/tools/)
* [How to install aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


### Creating your cluster

1. In order to use AWS EKS we need to be authenticated to an AWS account to create resources:


### AWS credentials
* You will need to run `aws configure` to set up for your [account](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html): 

* Under `cloud/aws/variables.tf` set `region` to the region you want to build EKS clusters under. Validate that the chosen region [supports EKS](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/). 


### Accessing Resources 
* Locate/Validate your cluster name
```sh
aws eks --region  <REGION> list-clusters
```
* Access Kubernetes Cluster 
```sh
 aws eks --region <REGION>  update-kubeconfig --name <CLUSTER-NAME>
```



