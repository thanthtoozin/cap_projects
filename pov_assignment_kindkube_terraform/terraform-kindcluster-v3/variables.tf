variable "cluster_name" {
  type        = string
  description = "This is the name of kind cluster"
  default     = "sg-cluster"
}

variable "k8s_image" {
  type        = string
  description = "This is node image of kind cluster"
  default     = "kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f"
}

variable "masternode_count" {
  type        = number
  description = "The number of master nodes"
  default     = 1
}

variable "workernode_count" {
  type        = number
  description = "The number of worker nodes"
  default     = 3
}