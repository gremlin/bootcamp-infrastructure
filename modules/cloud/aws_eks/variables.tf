variable "group_id" {
    type = string
}

variable "vpc_id" {
    type = string
    description = "The VPC ID where we are going to provision the EKS cluster."
}

variable "public_subnet_ids" {
    type = list(string)
    default = []
    description = "(optional) A subset of subnet IDs in the VPC to use for AWS EKS."
}

variable "private_subnet_ids" {
    type = list(string)
    default = []
    description = "(optional) A subset of subnet IDs in the VPC to use for AWS EKS."
}

variable "public_access_cidrs" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "(optional) A list of CIDR ranges which will be allowed access to the EKS cluster. If none is provided, the cluster will be globally accessible."
}

variable "eks_security_group_ids" {
    type = list(string)
    default = []
    description = "(optional) A list of VPC Security Group IDs to attach to the public kubernetes API endpoint. By default no Security Groups will be attached."
}

variable "eks_instance_types" {
    type = list(string)
    default = []
    description = "(optional) A list of AWS instance types which you'd like to provision for the EKS cluster. A default set of instance types (found in variables.tf) will be used if not provided."
}

variable "tags" {
    type = list(map(any))
    default = []
    description = "(optional) A list of aws tags (maps) to apply to all resources created by this terraform module. Name tags will be assigned automatically in addition to any tags provided here."
}