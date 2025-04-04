variable "location" {
  description = "Location to be deployed"
  type = string
  default = "East US"
}

variable "environment" {
  description = "Environment to be deployed"
  type = string
  default = "dev"
}

variable "cluster_name" {
  description = "Name of the cluster"
  type = string
  default = "n5-test-cluster"
}

variable "default_node_pool_count" {
  description = "Node pool count default on cluster"
  type = number
  default = 1
}

variable "default_node_pool_vm_size" {
  description = "Node pool vm size default on cluster"
  type = string
  default = "Standard_D2_v2"
}
