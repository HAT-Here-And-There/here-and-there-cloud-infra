module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.13.0"

  cluster_name                   = format(module.naming.result, "eks")
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true

  create_cluster_security_group = true
  create_node_security_group    = false

  node_security_group_id = module.sg_for_eks_node.security_group_id

  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {
    # Complete
    backend = {
      name       = format(module.naming.result, "node-group")
      subnet_ids = module.vpc.private_subnets

      min_size     = 2
      max_size     = 3
      desired_size = 2

      enable_monitoring = true

      create_iam_role = true
      iam_role_name   = format(module.naming.result, "node-group-role")

      launch_template_tags = {
        # enable discovery of autoscaling groups by cluster-autoscaler
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${format(module.naming.result, "eks")}" : "owned",
      }
    }
  }
}
