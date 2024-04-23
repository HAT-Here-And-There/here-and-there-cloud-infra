resource "linode_stackscript" "install_docker_mysql" {
  label       = format(module.naming.result, "install-docker-mysql")
  description = "install docker and run mysql"
  script = templatefile("./files/create-mysql.sh.tftpl", {
    password = var.db_password
  })
  images = ["linode/ubuntu22.04"]
}
