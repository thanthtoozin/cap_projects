resource "kind_cluster" "default" {
  name       = "cluster-v0"
  node_image = "kindest/node:v1.31.14@sha256:6f86cf509dbb42767b6e79debc3f2c32e4ee01386f0489b3b2be24b0a55aac2b"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
}