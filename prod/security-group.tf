module "sg_for_elasticache" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "elasticache-sg")
  description = "sg for elasticache cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "allow traffic from eks"
      source_security_group_id = module.eks.cluster_security_group_id
    },
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "allow traffic from bastion host"
      source_security_group_id = module.sg_for_bastion_host.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

module "sg_for_documentdb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "documentdb-sg")
  description = "sg for documentdb cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      description              = "allow traffic from eks"
      source_security_group_id = module.eks.cluster_security_group_id
    },
    {
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      description              = "allow traffic from bastion host"
      source_security_group_id = module.sg_for_bastion_host.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

module "sg_for_rds" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "rds-sg")
  description = "sg for rds instance"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "allow traffic from eks"
      source_security_group_id = module.eks.cluster_security_group_id
    },
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "allow traffic from bastion host"
      source_security_group_id = module.sg_for_bastion_host.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

module "sg_for_bastion_host" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "bastion-host-sg")
  description = "sg for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "allow temp all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]
}
