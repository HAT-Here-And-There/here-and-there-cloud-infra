module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.13.0"

  cluster_name                   = format(module.naming.result, "eks")
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true

  create_cluster_security_group                = true
  create_node_security_group                   = true
  node_security_group_enable_recommended_rules = true
  node_security_group_additional_rules = {
    bastion = {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "allow traffic from bastion host"
      source_security_group_id = module.sg_for_bastion_host.security_group_id
      type                     = "ingress"
    },
    ingress_from_control_plane = {
      type = "ingress"
      # Feel free to change these to your desired ports
      # Port `0` and protocol `-1` mean that I trust the control plane enough to allow ingresses of any ports & protocols to my worker nodes
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      # `cluster_security_group` is the security group that control plane uses
      source_cluster_security_group = true
    },
    ping = {
      type = "ingress"
      # Feel free to change these to your desired ports
      # Port `0` and protocol `-1` mean that I trust the control plane enough to allow ingresses of any ports & protocols to my worker nodes
      from_port   = -1
      to_port     = -1
      protocol    = "ICMP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t2.small"]
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
