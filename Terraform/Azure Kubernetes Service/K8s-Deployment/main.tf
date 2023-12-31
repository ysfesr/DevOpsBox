data "azurerm_resource_group" "rg" {
  name = "prod-rg"
}

# create k8s 
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name
  default_node_pool {
    name                = "system"
    node_count          = var.worker
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" # CNI
  }
}


# create role_assignment to authonction betwen eks and ecr
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
# create container registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}