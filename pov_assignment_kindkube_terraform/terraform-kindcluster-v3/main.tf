resource "kind_cluster" "default" {
  name       = var.cluster_name
  node_image = var.k8s_image

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    dynamic "node" {
      for_each = concat(
        [for i in range(var.masternode_count) : { role = "control-plane" }],
        [for i in range(var.workernode_count) : { role = "worker" }]
      )
      content {
        role = node.value.role
      }
    }
  }
}
