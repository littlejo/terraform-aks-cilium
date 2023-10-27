output "kube_config_raw" {
  description = "The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools."
  sensitive   = true
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
}

output "kube_host" {
  value = nonsensitive(azurerm_kubernetes_cluster.this.kube_config[0].host)
}
