# PBS TF CloudWatch Alarms Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-cloudwatch-alarms-module?ref=1.1.0
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a CloudWatch alarm.

It is an opinionated module that will configure CloudWatch alarms with as little manual configuration as possible. See the examples located in the [examples folder](/examples) to see what kind of resources are supported.

Integrate this module like so:

```hcl
module "alarm" {
  source = "github.com/pbs/terraform-aws-cloudwatch-alarms-module?ref=1.1.0"

  namespace       = "AWS/Lambda"
  lambda_function = aws_lambda_function.lambda.id

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

`1.1.0`

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_metric_filter.filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_metric_alarm.alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the alarm's associated metric. Supports AWS managed namespaces (e.g. AWS/Lambda, AWS/Kinesis, AWS/States, AWS/SES, AWS/SQS, AWS/MediaTailor) and custom application namespaces. | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | Actions to take when the CloudWatch Alarm fires. | `set(string)` | `null` | no |
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | Description of the alarm being created. Defaults to Alarm for {local.name} Errors (High) if null. | `string` | `null` | no |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. Additionally, the values LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, and GreaterThanUpperThreshold are used only for alarms based on anomaly detection models. | `string` | `"GreaterThanOrEqualToThreshold"` | no |
| <a name="input_datapoints_to_alarm"></a> [datapoints\_to\_alarm](#input\_datapoints\_to\_alarm) | Datapoints to alarm. | `number` | `1` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | The number of periods over which data is compared to the specified threshold. | `number` | `1` | no |
| <a name="input_kinesis_stream"></a> [kinesis\_stream](#input\_kinesis\_stream) | Name of the Kinesis stream being monitored | `string` | `null` | no |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | Name of the Lambda function being monitored | `string` | `null` | no |
| <a name="input_log_metric_filter"></a> [log\_metric\_filter](#input\_log\_metric\_filter) | Configuration for an optional aws\_cloudwatch\_log\_metric\_filter to create alongside the alarm. When set, a log metric filter is deployed that feeds the named metric into the alarm. | <pre>object({<br/>    name           = string<br/>    pattern        = string<br/>    log_group_name = string<br/>    default_value  = optional(string, "0")<br/>    value          = optional(string, "1")<br/>  })</pre> | `null` | no |
| <a name="input_mediatailor_configuration_name"></a> [mediatailor\_configuration\_name](#input\_mediatailor\_configuration\_name) | Name of the MediaTailor configuration being monitored | `string` | `null` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | Metric to use for this alarm. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the alarm being created. Defaults to product if null. | `string` | `null` | no |
| <a name="input_period"></a> [period](#input\_period) | The period in seconds over which the specified statistic is applied. | `number` | `60` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the SQS queue being monitored | `string` | `null` | no |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | SNS topic ARN associated with Lambda that handles payload delivery. | `string` | `null` | no |
| <a name="input_state_machine_arn"></a> [state\_machine\_arn](#input\_state\_machine\_arn) | ARN of the state machine being monitored | `string` | `null` | no |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | The statistic to apply to the alarm's associated metric. Any of the following are supported: SampleCount, Average, Sum, Minimum, Maximum. | `string` | `"Sum"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models. | `string` | `null` | no |
| <a name="input_treat_missing_data"></a> [treat\_missing\_data](#input\_treat\_missing\_data) | How to treat data that is missing. | `string` | `"notBreaching"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the alarm provisioned |
| <a name="output_name"></a> [name](#output\_name) | Name of the alarm provisioned |
