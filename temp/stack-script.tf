resource "linode_stackscript" "install_docker_postgresql" {
  label       = format(module.naming.result, "install-docker-postgresql")
  description = "install docker and run postgresql"
  script = templatefile("./files/create-postgresql.sh.tftpl", {
    password = var.db_password
  })
  images = ["linode/ubuntu22.04"]
}
