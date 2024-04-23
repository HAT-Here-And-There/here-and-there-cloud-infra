resource "linode_lke_cluster" "cluster" {
  label       = format(module.naming.result, "lke-cluster")
  k8s_version = "1.28"
  region      = "jp-osa"

  pool {
    type  = "g6-standard-1"
    count = 4
    autoscaler {
      min = 4
      max = 4
    }
  }
}
