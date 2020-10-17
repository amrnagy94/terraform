resource "azurerm_kubernetes_cluster_node_pool" "node-pool02" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 3

  tags = {
    Environment = "Production"
  }
  
}