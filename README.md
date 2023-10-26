<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.77.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.77.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_subnet.node](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/subnet) | resource |
| [azurerm_subnet.pod](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.77.0/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location (az group list \| jq -r .[0].location) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name (az group list \| jq -r .[0].name) | `string` | n/a | yes |
| <a name="input_subnet_node"></a> [subnet\_node](#input\_subnet\_node) | Feature of subnet of node | `any` | <pre>{<br>  "address_prefixes": [<br>    "10.240.0.0/16"<br>  ],<br>  "name": "nodesubnet"<br>}</pre> | no |
| <a name="input_subnet_pod"></a> [subnet\_pod](#input\_subnet\_pod) | Feature of subnet of pod | `any` | <pre>{<br>  "address_prefixes": [<br>    "10.241.0.0/16"<br>  ],<br>  "name": "podsubnet"<br>}</pre> | no |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | Feature of vnet | `any` | <pre>{<br>  "address_space": [<br>    "10.0.0.0/8"<br>  ],<br>  "name": "cilium-tf"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | The `azurerm_kubernetes_cluster`'s `kube_config_raw` argument. Raw Kubernetes config to be used by [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and other compatible tools. |
<!-- END_TF_DOCS -->