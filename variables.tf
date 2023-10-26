variable "resource_group_name" {
  description = "Resource Group Name (az group list | jq -r .[0].name)"
  type        = string
}

variable "location" {
  description = "Location (az group list | jq -r .[0].location)"
  type        = string
}

variable "vnet" {
  description = "Feature of vnet"
  type        = any
  default = {
    address_space = ["10.0.0.0/8"]
    name          = "cilium-tf"
  }
}

variable "subnet_node" {
  description = "Feature of subnet of node"
  type        = any
  default = {
    address_prefixes = ["10.240.0.0/16"]
    name             = "nodesubnet"
  }
}

variable "subnet_pod" {
  description = "Feature of subnet of pod"
  type        = any
  default = {
    address_prefixes = ["10.241.0.0/16"]
    name             = "podsubnet"
  }
}
