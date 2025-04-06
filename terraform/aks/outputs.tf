output "id" {
  value = data.azurerm_resource_group.n5_test_rg.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true
}

output "acr_login_server" {
  value = data.azurerm_container_registry.acr.login_server
}