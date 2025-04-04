provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "n5_test_rg" {
  name = "rg-n5-blob-storage"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name = var.cluster_name
  location = data.azurerm_resource_group.n5_test_rg.location
  resource_group_name = data.azurerm_resource_group.n5_test_rg.name
  dns_prefix = var.cluster_name

  default_node_pool {
    name = "default"
    node_count = var.default_node_pool_count
    vm_size = var.default_node_pool_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    managed-by = "terraform"
  }

}