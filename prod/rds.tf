module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.6.0"

  identifier = format(module.naming.result, "rds")

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.micro"

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = false
  password                    = var.db_password
  port                        = 5432

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.sg_for_rds.security_group_id]

  create_cloudwatch_log_group = true

  skip_final_snapshot = true
  deletion_protection = false
  allocated_storage   = 20
}
