# PBS TF Virtual Service Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-virtual-service-module?ref=0.0.30
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions an App Mesh virtual service that fronts a virtual router or a virtual node.

If your service is relatively simple you'll likely want to use a virtual node backend. If you would like to provide more complicated routing to the compute backing your virtual service, you'll want to use a virtual router backend.

Integrate this module like so:

### Virtual Node Example

```hcl
module "virtual-service" {
  source = "github.com/pbs/terraform-aws-virtual-service-module?ref=0.0.30"

  mesh_name = module.mesh.id

  virtual_node_name = aws_appmesh_virtual_node.node.name

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

### Virtual Router Example

```hcl
module "virtual-service" {
  source = "github.com/pbs/terraform-aws-virtual-service-module?ref=0.0.30"

  mesh_name = module.mesh.id

  virtual_router_name = aws_appmesh_virtual_router.router.name

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`0.0.30`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appmesh_virtual_service.virtual_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_service) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_mesh_name"></a> [mesh\_name](#input\_mesh\_name) | Name of the mesh this virtual service is associated with | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the virtual service. If null, defaults to product. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_virtual_node_name"></a> [virtual\_node\_name](#input\_virtual\_node\_name) | The name of the virtual node this virtual service is associated with. If null, it's assumed that virtual\_router\_name is populated. | `string` | `null` | no |
| <a name="input_virtual_router_name"></a> [virtual\_router\_name](#input\_virtual\_router\_name) | The name of the virtual router this virtual service is associated with. If null, it's assumed that virtual\_node\_name is populated. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the virtual service |
| <a name="output_id"></a> [id](#output\_id) | ID of the virtual service |
| <a name="output_name"></a> [name](#output\_name) | Name of the virtual service |
