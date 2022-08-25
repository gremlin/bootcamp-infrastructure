# EKS Role
data "aws_iam_policy_document" "eks_assumerole_policy" {
    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "eks" {
    name = "group-${var.group_id}-eks-cluster-service-role"
    assume_role_policy = data.aws_iam_policy_document.eks_assumerole_policy.json
}

locals {
    eks_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
        "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    ]
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    for_each = toset(local.eks_policies)

    role = aws_iam_role.eks.name
    policy_arn = each.value
}


# EKS NodeGroup Role
data "aws_iam_policy_document" "nodegroup_assumerole_policy" {
    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "eks_nodegroup" {
    name = "group-${var.group_id}-eks-nodegroup-role"
    assume_role_policy = data.aws_iam_policy_document.nodegroup_assumerole_policy.json
}

locals {
    eks_nodegroup_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
}

resource "aws_iam_role_policy_attachment" "eks_nodegroup_policy" {
    for_each = toset(local.eks_nodegroup_policies)

    role = aws_iam_role.eks_nodegroup.name
    policy_arn = each.value
}

data "aws_region" "current" {}

data "aws_caller_identity" "self" {}

locals {
    eks_oid_identifier = regex(
        "[^/]*$",
        aws_eks_cluster.this.identity[0].oidc[0].issuer
    )
    account_id = data.aws_caller_identity.self.account_id
    region = data.aws_region.current.name
}

output "eks_cluster_identity" {
    value = local.eks_oid_identifier
}

data "tls_certificate" "eks_cluster" {
    url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
