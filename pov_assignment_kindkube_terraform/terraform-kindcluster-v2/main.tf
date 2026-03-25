resource "kind_cluster" "default" {
  name       = var.cluster_name
  node_image = var.k8s_image

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    dynamic "node" {
      for_each = range(var.masternode_count)
      content {
        role = "control-plane"
      }
    }

    dynamic "node" {
      for_each = range(var.workernode_count)
      content {
        role = "worker"
      }
    }
  }
}
