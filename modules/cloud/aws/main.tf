module "eks" {
  source = "terraform-aws-modules/eks/aws"
  // version = "18.9.0.0"

  cluster_name    = "group-${var.group_id}"
  cluster_version = "1.21"
  // cluster_endpoint_private_access = true
  // cluster_endpoint_public_access  = true
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  // cluster_encryption_config = [{
  //   provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  //   resources        = ["secrets"]
  // }]

  eks_managed_node_groups = {
    # Default node group - as provided by AWS EKS
    default_node_group = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      create_launch_template = false
      launch_template_name   = ""
      asg_desired_capacity   = var.cluster_asg_desired_capacity
      asg_max_size           = var.cluster_asg_max_size
      instance_type          = var.cluster_instance_type
    }

  }

  // eks_managed_node_groups = [
  //   {
  // asg_desired_capacity = var.cluster_asg_desired_capacity
  // asg_max_size         = var.cluster_asg_max_size
  // instance_type        = var.cluster_instance_type
  //   }
  // ]
}
