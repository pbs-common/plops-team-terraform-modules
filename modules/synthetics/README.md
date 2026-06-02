# PBS TF Synthetics Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-synthetics-module?ref=3.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Creates a basic CloudWatch Synthetics Canary, along with the accoutrement to utilize it effectively.

Integrate this module like so:

```hcl
module "synthetics" {
  source = "github.com/pbs/terraform-aws-synthetics-module?ref=3.0.1"

  zip_file = "path/to/file.zip"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

Note that either a `zip_file` or a `canary_script_s3_location` must be provided to provide code for the canary to run.

An example showing how to use Terraform to generate a canary can be found in the [basic example](./examples/basic).

Note that this is not advised for most use-cases. `data` resources in Terraform are assumed to have no side effects (like creating a zip file), and you will run into trouble if you use this approach for frequent canary adjustments.

The recommended workaround for this is to use something external to Terraform (like a bash script or [Terragrunt](https://terragrunt.gruntwork.io/)) to handle the zip file creation, and then use Terraform to deploy the canary.

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`3.0.1`

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role"></a> [role](#module\_role) | github.com/pbs/terraform-aws-iam-role-module.git | 1.0.0 |
| <a name="module_s3"></a> [s3](#module\_s3) | github.com/pbs/terraform-aws-s3-module | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_synthetics_canary.canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_alarm_config"></a> [alarm\_config](#input\_alarm\_config) | Configurations for the alarm | <pre>object({<br/>    actions_enabled           = optional(bool, true)<br/>    comparison_operator       = optional(string, "LessThanThreshold")<br/>    period                    = optional(number, 300)<br/>    evaluation_periods        = optional(number, 1)<br/>    metric_name               = optional(string, "SuccessPercent")<br/>    namespace                 = optional(string, "CloudWatchSynthetics")<br/>    statistic                 = optional(string, "Sum")<br/>    datapoints_to_alarm       = optional(number, 1)<br/>    threshold                 = optional(string, "90")<br/>    alarm_actions             = optional(list(string), [])<br/>    ok_actions                = optional(list(string), [])<br/>    insufficient_data_actions = optional(list(string), [])<br/>    treat_missing_data        = optional(string, "missing")<br/>    description               = optional(string)<br/>  })</pre> | <pre>{<br/>  "actions_enabled": true,<br/>  "alarm_actions": [],<br/>  "comparison_operator": "LessThanThreshold",<br/>  "datapoints_to_alarm": 1,<br/>  "description": null,<br/>  "evaluation_periods": 1,<br/>  "insufficient_data_actions": [],<br/>  "metric_name": "SuccessPercent",<br/>  "namespace": "CloudWatchSynthetics",<br/>  "ok_actions": [],<br/>  "period": 300,<br/>  "statistic": "Sum",<br/>  "threshold": "90",<br/>  "treat_missing_data": "missing"<br/>}</pre> | no |
| <a name="input_artifact_config"></a> [artifact\_config](#input\_artifact\_config) | Configuration for canary artifacts, including the encryption-at-rest settings for artifacts that the canary uploads to Amazon S3. | <pre>object({<br/>    s3_encryption = optional(object({<br/>      encryption_mode = optional(string)<br/>      kms_key_arn     = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_canary_script_s3_location"></a> [canary\_script\_s3\_location](#input\_canary\_script\_s3\_location) | Location in Amazon S3 where Synthetics stores the canary script for a canary. Conflicts with `zip_file`. | <pre>object({<br/>    bucket  = optional(string)<br/>    key     = optional(string)<br/>    version = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_delete_lambda"></a> [delete\_lambda](#input\_delete\_lambda) | Specifies whether to also delete the Lambda functions and layers used by this canary. | `bool` | `false` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ARN of the IAM role to be used to run the canary. | `string` | `null` | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the execution role created by this module, if one is created. If null, will default to name. | `string` | `null` | no |
| <a name="input_failure_retention_period"></a> [failure\_retention\_period](#input\_failure\_retention\_period) | Number of days to retain data about failed runs of this canary. | `number` | `31` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Specifies whether to force destroy the bucket containing the canary artifacts. This is required when the bucket contains objects. The default value is `false`. | `bool` | `false` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Entry point to use for the source code when running the canary. This value must end with the string `.handler`. | `string` | `"canary.handler"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the synthetics module. If null, will default to product. | `string` | `null` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | Policy JSON. If null, default policy granting S3, logging, and XRay will be attached | `string` | `null` | no |
| <a name="input_run_config"></a> [run\_config](#input\_run\_config) | Configuration block for individual canary runs. | <pre>object({<br/>    timeout_in_seconds    = optional(number)<br/>    memory_in_mb          = optional(number)<br/>    active_tracing        = optional(bool)<br/>    environment_variables = optional(map(string))<br/>  })</pre> | `null` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Specifies the runtime version to use for the canary. For a list of valid runtime versions, see Canary Runtime Versions. | `string` | `"syn-nodejs-puppeteer-11.0"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Schedule for how often the canary is to run and when these test runs are to stop. | <pre>object({<br/>    expression          = string<br/>    duration_in_seconds = optional(number)<br/>  })</pre> | <pre>{<br/>  "expression": "rate(5 minutes)"<br/>}</pre> | no |
| <a name="input_snapshot_bucket_name"></a> [snapshot\_bucket\_name](#input\_snapshot\_bucket\_name) | Name of the bucket to store snapshots in. If null, will default to name. | `string` | `null` | no |
| <a name="input_start_canary"></a> [start\_canary](#input\_start\_canary) | Specifies whether this canary is to run after it is created. | `bool` | `true` | no |
| <a name="input_success_retention_period"></a> [success\_retention\_period](#input\_success\_retention\_period) | Number of days to retain data about successful runs of this canary. The valid range is 1 to 455 days. | `number` | `31` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Specifies the VPC settings of the canary. | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_zip_file"></a> [zip\_file](#input\_zip\_file) | ZIP file that contains the script, if you input your canary script directly into the canary instead of referring to an S3 location. It can be up to 225KB. Conflicts with `canary_script_s3_location`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the canary |
| <a name="output_engine_arn"></a> [engine\_arn](#output\_engine\_arn) | ARN of the Lambda function that is used as your canary's engine |
| <a name="output_execution_role_name"></a> [execution\_role\_name](#output\_execution\_role\_name) | Name of the IAM role used to run the canary |
| <a name="output_id"></a> [id](#output\_id) | Name of the canary |
| <a name="output_name"></a> [name](#output\_name) | Name of the canary |
| <a name="output_source_location_arn"></a> [source\_location\_arn](#output\_source\_location\_arn) | ARN of the Lambda layer where Synthetics stores the canary script code |
| <a name="output_status"></a> [status](#output\_status) | Status of the canary |
| <a name="output_timeline"></a> [timeline](#output\_timeline) | Timeline of the canary |
