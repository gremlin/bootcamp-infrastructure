# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "default" {
  default = true
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet
data "aws_subnet" "default" {
  for_each = toset(var.subnet_az)

  availability_zone = "${var.region}${each.key}"
  default_for_az    = true
  vpc_id            = data.aws_vpc.default.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

variable "group_id" {
  type        = string
  description = "The id or number of the bootcamp group."

  validation {
    condition     = can(regex("^[0-9A-Za-z_-]+$", var.group_id))
    error_message = "Enter a valid group id number. Tip: it doesnt strictly need to be a number (e.g. you could create a group named 00-yourname), but it must only contain letters, numbers, underscores and dashes."
  }
}
