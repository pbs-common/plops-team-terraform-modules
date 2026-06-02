# PBS TF Lambda Permission Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-lambda-permission-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Grants a Lambda function to be invoked by a specific service.

Integrate this module like so:

```hcl
module "lambda_permission" {
  source = "github.com/pbs/terraform-aws-lambda-permission-module?ref=1.0.1"

  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.name
  principal     = "sns.amazonaws.com"
  source_arn    = module.topic.arn
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
| [aws_lambda_permission.lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | Action for the Lambda Permission | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Function Name for the Lambda Permission | `string` | n/a | yes |
| <a name="input_principal"></a> [principal](#input\_principal) | Principal for the Lambda Permission | `string` | n/a | yes |
| <a name="input_source_arn"></a> [source\_arn](#input\_source\_arn) | Source ARN for the Lambda Permission | `string` | n/a | yes |
| <a name="input_statement_id"></a> [statement\_id](#input\_statement\_id) | Statement ID for the Lambda Permission | `string` | n/a | yes |

## Outputs

No outputs.
