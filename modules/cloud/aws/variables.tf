# AWS Credentials for resource creation 

variable "cluster_instance_type" {
  type        = string
  description = "EC2 instance type for the EKS autoscaling group."
  default     = "t3.medium"
}
# variable "cluster_asg_desired_capacity" {
#   type        = number
#   description = "The default number of EC2 instances our EKS cluster runs."
#   default     = 3
# }

# variable "cluster_asg_max_size" {
#   type        = number
#   description = "The maximum number of EC2 instances our EKS cluster will have."
#   default     = 4
# }

variable "region" {
  type        = string
  description = "AWS US-based Region that will be used for infrastructure."
  default     = "us-west-1"
}

// provider "aws" {
//   region     = "us-west-2"
//   access_key = "my-access-key"
//   secret_key = "my-secret-key"
// }


variable "subnet_az" {
  type        = list(string)
  description = "List of strings of Availability Zone suffixes."

  default = [
    "a",
    "c",
  ]
}

variable "k8s_version_do" {
  type        = string
  description = "The version of Kubernetes to use. To see available versions use the command: doctl kubernetes options versions"
  # Note that Kubernetes 1.20 and above use the containerd runtime. Set the runtime in outputs.tf
  default = "1.21.9-do.0"
}
variable "k8s_version_aws" {
  type        = string
  description = "The version of Kubernetes to use. To see available versions visit: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html (pass minor version, 1.21 not 1.21.1.0)"
  default     = "1.21"
}
