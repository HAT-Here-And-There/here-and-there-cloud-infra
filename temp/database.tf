resource "linode_instance" "database" {
  label     = format(module.naming.result, "database")
  image     = "linode/ubuntu22.04"
  region    = "jp-osa"
  type      = "g6-standard-2"
  root_pass = var.instance_password

  stackscript_id = linode_stackscript.install_docker_mysql.id
}
