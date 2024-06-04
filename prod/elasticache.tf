resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = format(module.naming.result, "elasticache-cluster")
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_group.name

  security_group_ids = [module.sg_for_elasticache.security_group_id]
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = format(module.naming.result, "elasticache-subnet-group")
  subnet_ids = module.vpc.database_subnets
}
