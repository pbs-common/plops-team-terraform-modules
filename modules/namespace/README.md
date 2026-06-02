# PBS TF Namespace Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-namespace-module?ref=0.1.26
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a CloudMap namespace.

There are three types of namespaces that you might want to provision:

- HTTP
- Private
- Public

[This][cloudmap-docs] is where you can start learning about this service.

To put it simply, an HTTP namespace is a namespace that allows services to be discovered by AWS services that integrate with CloudMap (usually App Mesh).

e.g. `app.example-http-namespace`

A private namespace is effectively a private hosted zone that is managed by AWS. A service that is registered with a private namespace will receive a DNS record that is only resolvable within the VPC that the namespace is associated with.

e.g. `app.example.private`

A public namespace is effectively a public hosted zone that is managed by AWS. A service that is registered with a public namespace will receive a DNS record that is resolvable globally.

e.g. `app.example.com`

Integrate this module like so:

### HTTP Namespace

```hcl
module "namespace" {
  source = "github.com/pbs/terraform-aws-namespace-module?ref=0.1.26"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

### Private Namespace

```hcl
module "namespace" {
  source = "github.com/pbs/terraform-aws-namespace-module?ref=0.1.26"

  type = "private"
  name = "example.private"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

### Public Namespace

```hcl
module "namespace" {
  source = "github.com/pbs/terraform-aws-namespace-module?ref=0.1.26"

  type = "public"
  name = "example.org"

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

`0.1.26`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs
[cloudmap-docs]: https://docs.aws.amazon.com/cloud-map/latest/dg/what-is-cloud-map.html

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
| [aws_service_discovery_http_namespace.namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [aws_service_discovery_private_dns_namespace.namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_public_dns_namespace.namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_public_dns_namespace) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the namespace. If null, will default to `{name} namespace`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the namespace. If null, will default to product. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of the namespace. | `string` | `"http"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC for a private namespace. If null, will be looked up based on the environment parameter. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the CloudMap Namespace |
| <a name="output_hosted_zone"></a> [hosted\_zone](#output\_hosted\_zone) | Hosted Zone of the CloudMap Namespace |
| <a name="output_id"></a> [id](#output\_id) | ID of the CloudMap Namespace |
| <a name="output_name"></a> [name](#output\_name) | Name of the CloudMap Namespace |
