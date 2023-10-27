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

  url  = split(":", split("https://", azurerm_kubernetes_cluster.this.kube_config[0].host)[1])[0]
  port = split(":", split("https://", azurerm_kubernetes_cluster.this.kube_config[0].host)[1])[1]

  kubeproxy_replace_options = var.cilium.kube-proxy-replacement ? "--set kubeProxyReplacement=true --set k8sServiceHost=${local.url} --set k8sServicePort=${local.port}" : ""
  ebpf_hostrouting_options  = var.cilium.kube-proxy-replacement && var.cilium.ebpf-hostrouting ? "--set bpf.masquerade=true" : ""
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

resource "terraform_data" "kube_proxy_disable" {
  count = var.cilium.type == "cilium_custom" && var.cilium.kube-proxy-replacement ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl -n kube-system patch daemonset kube-proxy -p '\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"non-existing\": \"true\"}}}}'"
    environment = {
      KUBECONFIG = "./kubeconfig"
    }
  }

  depends_on = [
    local_file.this
  ]
}

resource "terraform_data" "cilium_install" {
  count = var.cilium.type == "cilium_custom" ? 1 : 0
  provisioner "local-exec" {
    command = "cilium install --version ${var.cilium.version} --set azure.resourceGroup='${var.resource_group_name}' ${local.kubeproxy_replace_options} ${local.ebpf_hostrouting_options}"
    environment = {
      KUBECONFIG = "./kubeconfig"
    }
  }

  depends_on = [
    terraform_data.kube_proxy_disable,
    local_file.this
  ]
}
