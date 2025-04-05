provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "n5_test_rg" {
  name = "rg-n5-blob-storage"
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.n5_test_rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
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

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

data "azurerm_container_registry" "acr" {
  name                = azurerm_container_registry.acr.name
  resource_group_name = data.azurerm_resource_group.n5_test_rg.name
}

resource "null_resource" "docker_build_push" {
  provisioner "local-exec" {
    command = <<EOT
      az acr login --name ${data.azurerm_container_registry.acr.name}
      docker build -f ../docker/Dockerfile -t ${data.azurerm_container_registry.acr.login_server}/${var.image_name}:${var.image_tag} ../docker
      docker push ${data.azurerm_container_registry.acr.login_server}/${var.image_name}:${var.image_tag}
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
}
