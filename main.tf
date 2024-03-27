locals {
  network = {
    byocni = {
      network_plugin  = "none"
      network_policy  = null
      ebpf_data_plane = null
    }
    cilium_custom = {
      network_plugin  = "none"
      network_policy  = null
      ebpf_data_plane = null
    }
    cilium_azure = {
      network_plugin  = "azure"
      network_policy  = "cilium"
      ebpf_data_plane = "cilium"
    }
  }
}

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
  count                = var.cilium.type == "cilium_azure" ? 1 : 0
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
  name               = var.aks.name
  kubernetes_version = var.aks.version

  azure_policy_enabled = true

  dns_prefix = var.aks.dns_prefix

  default_node_pool {
    name           = var.aks.default_node_pool.name
    node_count     = var.aks.default_node_pool.node_count
    vm_size        = var.aks.default_node_pool.vm_size
    vnet_subnet_id = azurerm_subnet.node.id
    pod_subnet_id  = var.cilium.type == "cilium_azure" ? azurerm_subnet.pod[0].id : null
  }

  network_profile {
    network_plugin  = local.network[var.cilium.type].network_plugin
    network_policy  = local.network[var.cilium.type].network_policy
    ebpf_data_plane = local.network[var.cilium.type].ebpf_data_plane
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

resource "cilium" "this" {
  count = var.cilium.type == "cilium_custom" ? 1 : 0
  set = [
    "aksbyocni.enabled=true",
    "nodeinit.enabled=true",
    "azure.resourceGroup=${var.resource_group_name}"
  ]
  version    = var.cilium.version
  depends_on = [local_file.this]
}
