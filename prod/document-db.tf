resource "aws_docdb_cluster" "document_db_cluster" {
  cluster_identifier  = format(module.naming.result, "documentdb-cluster")
  engine              = "docdb"
  master_username     = var.mongo_username
  master_password     = var.mongo_password
  skip_final_snapshot = true

  availability_zones = module.vpc.azs

  db_subnet_group_name = aws_docdb_subnet_group.document_db_subnet_group.name

  vpc_security_group_ids = [module.sg_for_documentdb.security_group_id]

  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  port                            = 27017

  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.custom.name
}

resource "aws_docdb_subnet_group" "document_db_subnet_group" {
  name       = format(module.naming.result, "documentdb-subnet-group")
  subnet_ids = module.vpc.database_subnets
}

resource "aws_docdb_cluster_instance" "document_db" {
  identifier         = format(module.naming.result, "documentdb-instance")
  cluster_identifier = aws_docdb_cluster.document_db_cluster.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster_parameter_group" "custom" {
  family      = "docdb5.0"
  name        = format(module.naming.result, "documentdb-cluster-parameter-group")
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}
