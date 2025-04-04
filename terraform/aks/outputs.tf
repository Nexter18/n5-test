output "id" {
  value = data.azurerm_resource_group.example.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true
}