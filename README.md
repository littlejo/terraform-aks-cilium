<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.77.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.77.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_subnet.node](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/subnet) | resource |
| [azurerm_subnet.pod](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/virtual_network) | resource |
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [terraform_data.cilium_install](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.kube_proxy_disable](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks"></a> [aks](#input\_aks) | Feature of aks | `any` | <pre>{<br>  "default_node_pool": {<br>    "name": "default",<br>    "node_count": 3,<br>    "vm_size": "Standard_DS2_v2"<br>  },<br>  "dns_prefix": "cilium",<br>  "name": "cilium-cluster-tf",<br>  "version": "1.27"<br>}</pre> | no |
| <a name="input_cilium"></a> [cilium](#input\_cilium) | Feature of cilium | `any` | <pre>{<br>  "ebpf-hostrouting": "enabled",<br>  "kube-proxy": "disabled",<br>  "type": "cilium_custom",<br>  "version": "1.14.3"<br>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | Location (az group list \| jq -r '.[0].location') | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name (az group list \| jq -r '.[0].name') | `string` | n/a | yes |
| <a name="input_subnet_node"></a> [subnet\_node](#input\_subnet\_node) | Feature of subnet of node | `any` | <pre>{<br>  "address_prefixes": [<br>    "10.240.0.0/16"<br>  ],<br>  "name": "nodesubnet"<br>}</pre> | no |
| <a name="input_subnet_pod"></a> [subnet\_pod](#input\_subnet\_pod) | Feature of subnet of pod | `any` | <pre>{<br>  "address_prefixes": [<br>    "10.241.0.0/16"<br>  ],<br>  "name": "podsubnet"<br>}</pre> | no |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | Feature of vnet | `any` | <pre>{<br>  "address_space": [<br>    "10.0.0.0/8"<br>  ],<br>  "name": "cilium-tf"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools. |
| <a name="output_kube_host"></a> [kube\_host](#output\_kube\_host) | n/a |
<!-- END_TF_DOCS -->