resource "azurerm_virtual_network" "this" {
  address_space       = var.vnet.address_space
  name                = var.vnet.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "node" {
  address_prefixes     = var.subnet_node.address_prefixes
  name                 = var.subnet_node.name
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_subnet" "pod" {
  address_prefixes     = var.subnet_pod.address_prefixes
  name                 = var.subnet_pod.name
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = var.resource_group_name

  delegation {
    name = "aks-delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name               = "cilium-cluster-tf"
  kubernetes_version = "1.27"

  dns_prefix = "cilium"

  default_node_pool {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.node.id
    pod_subnet_id  = azurerm_subnet.pod.id
  }

  network_profile {
    network_plugin  = "azure"
    network_policy  = "cilium"
    ebpf_data_plane = "cilium"
  }

  identity {
    type = "SystemAssigned"
  }

  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "local_file" "this" {
  content  = azurerm_kubernetes_cluster.this.kube_config_raw
  filename = "${path.module}/kubeconfig"
}
