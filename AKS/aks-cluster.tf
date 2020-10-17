
provider "azurerm" {
  version = "=2.20.0"
  features {}
}


resource "azurerm_resource_group" "AKS" {
  name     = "aks-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "cluster-aks"
  location            = azurerm_resource_group.AKS.location
  resource_group_name = azurerm_resource_group.AKS.name
  dns_prefix          = "clusteraks"

  default_node_pool {
    name       = "aks01"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}

