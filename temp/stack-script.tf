resource "linode_stackscript" "install_docker_postgresql_mongo" {
  label       = format(module.naming.result, "install-docker-postgresql")
  description = "install docker and run postgresql"
  script = templatefile("./files/create-postgresql-mongo.sh.tftpl", {
    password = var.db_password
  })
  images = ["linode/ubuntu22.04"]
}

resource "linode_stackscript" "install_docker_redis" {
  label       = format(module.naming.result, "install-docker-redis")
  description = "install docker and run redis"
  script = templatefile("./files/create-redis.sh.tftpl", {
  })
  images = ["linode/ubuntu22.04"]
}
