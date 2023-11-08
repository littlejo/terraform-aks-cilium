variable "resource_group_name" {
  description = "Resource Group Name (az group list | jq -r '.[0].name')"
  type        = string
}

variable "location" {
  description = "Location (az group list | jq -r '.[0].location')"
  type        = string
}

variable "vnet" {
  description = "Feature of vnet"
  type        = object({ address_space = list(string), name = string })
  default = {
    address_space = ["10.0.0.0/8"]
    name          = "cilium-tf-helm"
  }
}

variable "subnet_node" {
  description = "Feature of subnet of node"
  type        = object({ address_prefixes = list(string), name = string })
  default = {
    address_prefixes = ["10.240.0.0/16"]
    name             = "nodesubnet"
  }
}

variable "subnet_pod" {
  description = "Feature of subnet of pod"
  type        = object({ address_prefixes = list(string), name = string })
  default = {
    address_prefixes = ["10.241.0.0/16"]
    name             = "podsubnet"
  }
}

variable "aks" {
  description = "Feature of aks"
  type        = any
  default = {
    name       = "cilium-cluster-tf-helm"
    version    = "1.27.3"
    dns_prefix = "cilium"
    default_node_pool = {
      name       = "default"
      node_count = 3
      vm_size    = "Standard_DS2_v2"
    }
  }
}

variable "cilium" {
  description = "Feature of cilium"
  type        = any
  default = {
    type                   = "cilium_custom" #other options: cilium_azure|byocni
    version                = "1.14.3"
    kube-proxy-replacement = true
    ebpf-hostrouting       = true
    hubble                 = true
    hubble-ui              = true
  }
}
