# PBS TF DynamoDB Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-dynamodb-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a DynamoDB table. The table will be configured to auto-scale by default, however there are manual scaling parameters that can be used as well, if desired.

It also supports global secondary indices through the `global_secondary_indices` parameter.

There is a `ttl` parameter available that configures TTL for the table. Specifying an attribute with this parameter sets it as the attribute that controls the TTL for that item.

Integrate this module like so:

```hcl
module "dynamodb" {
  source = "github.com/pbs/terraform-aws-dynamodb-module?ref=1.0.1"

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.dynamodb_table_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.dynamodb_table_write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.dynamodb_table_read_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.dynamodb_table_write_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to indicate resource/project owner | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_additional_attributes"></a> [additional\_attributes](#input\_additional\_attributes) | List of map of additional attributes. Necessary for global secondary indices | `list(map(any))` | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Billing mode for table | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable point in time recovery | `bool` | `true` | no |
| <a name="input_global_secondary_indices"></a> [global\_secondary\_indices](#input\_global\_secondary\_indices) | Map of global secondary indices | `map(any)` | `{}` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | DynamoDB Table Hash Key | `map(any)` | <pre>{<br/>  "name": "id",<br/>  "type": "S"<br/>}</pre> | no |
| <a name="input_local_secondary_indices"></a> [local\_secondary\_indices](#input\_local\_secondary\_indices) | Map of local secondary indices | `map(any)` | `{}` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum capacity for the database | `number` | `20` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity for the database | `number` | `5` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the table | `string` | `null` | no |
| <a name="input_prod_max_capacity"></a> [prod\_max\_capacity](#input\_prod\_max\_capacity) | Maximum capacity for the production database. Defaults to max\_capacity | `number` | `null` | no |
| <a name="input_prod_min_capacity"></a> [prod\_min\_capacity](#input\_prod\_min\_capacity) | Minimum capacity for the production database. Defaults to min\_capacity | `number` | `null` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | DynamoDB Table Range Key | `map(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_target_value"></a> [target\_value](#input\_target\_value) | Target value for the metric | `number` | `70` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Attribute to use for TTL. If null, will not use ttl | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the DynamoDB table |
| <a name="output_name"></a> [name](#output\_name) | Name of the DynamoDB table |
