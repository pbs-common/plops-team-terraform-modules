# PBS TF Virtual Gateway Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-virtual-gateway-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This modules provisions a basic virtual gateway for use in App Mesh. This is necessary to introduce ingress into a mesh.

Integrate this module like so:

```hcl
module "vgw" {
  source = "github.com/pbs/terraform-aws-virtual-gateway-module?ref=1.0.1"

  # Required Parameters
  mesh_name = module.mesh.id

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

`1.0.1`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_envoy_service"></a> [envoy\_service](#module\_envoy\_service) | github.com/pbs/terraform-aws-ecs-service-module | 7.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_appmesh_virtual_gateway.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appmesh_virtual_gateway) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_mesh_name"></a> [mesh\_name](#input\_mesh\_name) | The name for the App Mesh this service is associated with. | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | CNAME(s) that are allowed to be used for the envoy service. Default is `product`.`primary_hosted_zone`. e.g. [product.example.com] --> [example.com] | `list(string)` | `null` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | ECS cluster for service | `string` | `null` | no |
| <a name="input_cnames"></a> [cnames](#input\_cnames) | CNAME(s) that are going to be created for the envoy service in the primary\_hosted\_zone. This can be set to [] to avoid creating a CNAME for the app. This can be useful for CDNs. Default is `product`. e.g. [product] --> [product.example.com] | `list(string)` | `null` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the containers running the envoy service for the virtual gateway | `string` | `"envoy"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port the envoy service will expose | `number` | `8080` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | The listener protocol for the virtual gateway | `string` | `"http"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of load balancer to use for the envoy service | `string` | `"network"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The maximum capacity of tasks for this service | `number` | `2` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | The minimum capacity of tasks for this service | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual gateway. Will default to product if not defined. | `string` | `null` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to owner | `string` | `"example"` | no |
| <a name="input_primary_hosted_zone"></a> [primary\_hosted\_zone](#input\_primary\_hosted\_zone) | Name of the primary hosted zone for DNS. e.g. primary\_hosted\_zone = example.org --> service.example.org. If null, it is assumed that a private hosted zone will be used. | `string` | `null` | no |
| <a name="input_private_hosted_zone"></a> [private\_hosted\_zone](#input\_private\_hosted\_zone) | Name of the private hosted zone for DNS. e.g. private\_hosted\_zone = example.org --> service.example.private. If null, it is assumed that a public hosted zone will be used. | `string` | `null` | no |
| <a name="input_public_service"></a> [public\_service](#input\_public\_service) | Service should be provisioned in public subnet. Ignored if subnets defined. | `bool` | `true` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets for the Virtual Gateway service. If null, private and public subnets will be looked up based on environment tag and one will be selected based on public\_service. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. If null, one will be looked up based on environment tag. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the virtual gateway |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Domain name of the service backing the virtual gateway |
| <a name="output_name"></a> [name](#output\_name) | Name of the virtual gateway |
| <a name="output_service_sg"></a> [service\_sg](#output\_service\_sg) | SG of the service backing the virtual gateway |
