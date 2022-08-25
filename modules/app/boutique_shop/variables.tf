variable "group_id" {
    type = string
}

variable "aws_eks_security_groups" {
    type = list(string)
}

variable "k8s_platform" {
    type = string
}