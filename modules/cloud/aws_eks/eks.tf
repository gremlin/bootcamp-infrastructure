terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.26.0"
        }
    }
    required_version = "~> 1.1.9"
}

# Provision EKS Cluster
resource "aws_eks_cluster" "this" {
    name = "group-${var.group_id}-eks-cluster"
    role_arn = aws_iam_role.eks.arn

    vpc_config {
        subnet_ids = var.private_subnet_ids
        endpoint_public_access = true
        endpoint_private_access = false
        public_access_cidrs = var.public_access_cidrs
        security_group_ids = var.eks_security_group_ids
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_policy
    ]
}

resource "aws_launch_template" "this" {
    name = "group-${var.group_id}-launch-template"

    credit_specification {
      cpu_credits = "standard"
    }
}

data "aws_launch_template" "this" {
    name = aws_launch_template.this.name
}

locals {
    eks_instance_types = coalescelist(
        var.eks_instance_types,
        [
            "t3.medium",
            "t3a.medium"
        ]
    )
}

resource "aws_eks_node_group" "this" {
    cluster_name = aws_eks_cluster.this.name
    node_group_name = "group-${var.group_id}-eks-nodegroup"
    node_role_arn = aws_iam_role.eks_nodegroup.arn
    subnet_ids = var.private_subnet_ids

    capacity_type = "SPOT"
    instance_types = local.eks_instance_types

    scaling_config {
        desired_size = 3
        min_size = 2
        max_size = 5
    }

    update_config {
        max_unavailable_percentage = 50
    }

    launch_template {
        name = data.aws_launch_template.this.name
        version = data.aws_launch_template.this.latest_version
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_nodegroup_policy
    ]
}