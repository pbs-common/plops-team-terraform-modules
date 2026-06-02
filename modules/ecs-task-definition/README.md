# PBS TF ECS Task Definition Module

## Installation

### Using the Repo Source

```hcl
github.com/pbs/terraform-aws-ecs-task-definition-module?ref=3.0.2
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This provisions a task definition for use with an ECS service.

Most of the time, you shouldn't have to use this module directly. It is integrated into the [ECS service module][ecs-service-module], allowing you to specify most important configurations that are relevant to your service there unless you have very particular needs for your task definition.

Integrate this module like so:

```hcl
module "task" {
  source = "github.com/pbs/terraform-aws-ecs-task-definition-module?ref=3.0.2"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
  image_repo = "nginx"
  image_tag = "latest"
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`3.0.2`

Note, however that subtrees can be altered as desired within repositories.

Further documentation on usage can be found [here](./docs).

Below is automatically generated documentation on this Terraform module using [terraform-docs][terraform-docs]

---

[terraform-docs]: https://github.com/terraform-docs/terraform-docs
[ecs-service-module]: https://github.com/pbs/terraform-aws-ecs-service-module

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.task_def](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.extra_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.extra_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cw_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.extra_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.extra_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_execution_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vgw_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.newrelic_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_awslogs_driver_mode"></a> [awslogs\_driver\_mode](#input\_awslogs\_driver\_mode) | (optional) awslogs driver mode. Set this to `blocking` if you would rather have an outage than lose logs. | `string` | `"non-blocking"` | no |
| <a name="input_command"></a> [command](#input\_command) | (optional) command to run in the container as an array. e.g. ["sleep", "10"]. If null, does not set a command in the task definition. | `list(string)` | `null` | no |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | (optional) JSON container definitions for task | `string` | `null` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | (optional) name for the container to have | `string` | `null` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | (optional) port the container is exposing | `number` | `80` | no |
| <a name="input_cpu_reservation"></a> [cpu\_reservation](#input\_cpu\_reservation) | (optional) CPU reservation for task | `number` | `256` | no |
| <a name="input_efs_mounts"></a> [efs\_mounts](#input\_efs\_mounts) | (optional) efs mount set of objects. Components should include dns\_name, container\_mount\_point, efs\_mount\_point | <pre>set(object({<br/>    file_system_id = string<br/>    efs_path       = string<br/>    container_path = string<br/>  }))</pre> | `[]` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | (optional) entrypoint to run in the container as an array. e.g. ["sleep", "10"]. If null, does not set an entrypoint in the task definition. | `list(string)` | `null` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | (optional) environment variables to be passed to the container. By default, only passes SSM\_PATH | `set(map(any))` | `null` | no |
| <a name="input_envoy_tag"></a> [envoy\_tag](#input\_envoy\_tag) | (optional) tag for envoy. Update periodically if using App Mesh. | `string` | `"v1.23.1.0-prod"` | no |
| <a name="input_extra_role_policy_json"></a> [extra\_role\_policy\_json](#input\_extra\_role\_policy\_json) | (optional) Extra IAM policy to attach to role used for this task without replacing defaults | `string` | `null` | no |
| <a name="input_extra_task_execution_role_policy_json"></a> [extra\_task\_execution\_role\_policy\_json](#input\_extra\_task\_execution\_role\_policy\_json) | (optional) Extra IAM policy to attach to task execution role used for this task without replacing defaults | `string` | `null` | no |
| <a name="input_image_repo"></a> [image\_repo](#input\_image\_repo) | (optional) image repo. e.g. image\_repo = nginx --> nginx:image\_tag | `string` | `"nginx"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | (optional) tag of the image. e.g. image\_tag = latest --> image\_repo:latest | `string` | `"alpine"` | no |
| <a name="input_log_group_class"></a> [log\_group\_class](#input\_log\_group\_class) | (Optional) log class of the log group. Possible values are: STANDARD or INFREQUENT\_ACCESS | `string` | `"INFREQUENT_ACCESS"` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | (optional) name for the log group | `string` | `null` | no |
| <a name="input_memory_reservation"></a> [memory\_reservation](#input\_memory\_reservation) | (optional) memory reservation for task | `number` | `512` | no |
| <a name="input_mesh_name"></a> [mesh\_name](#input\_mesh\_name) | (optional) the name for the App Mesh this task is associated with. If null, ignored | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS Task Definition Module. If null, will default to product. | `string` | `null` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | (optional) network mode for the task | `string` | `"awsvpc"` | no |
| <a name="input_newrelic_firelens_image"></a> [newrelic\_firelens\_image](#input\_newrelic\_firelens\_image) | Name for AWS Secrets Manager secret of New Relic Insights insert key. | `string` | `"533243300146.dkr.ecr.us-east-1.amazonaws.com/newrelic/logging-firelens-fluentbit"` | no |
| <a name="input_newrelic_secret_arn"></a> [newrelic\_secret\_arn](#input\_newrelic\_secret\_arn) | ARN for AWS Secrets Manager secret of New Relic Insights insert key. | `string` | `null` | no |
| <a name="input_newrelic_secret_name"></a> [newrelic\_secret\_name](#input\_newrelic\_secret\_name) | Name for AWS Secrets Manager secret of New Relic Insights insert key. | `string` | `null` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | (optional) capabilities that the task requires | `set(string)` | <pre>[<br/>  "FARGATE"<br/>]</pre> | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (optional) log retention in days | `number` | `7` | no |
| <a name="input_role_policy_json"></a> [role\_policy\_json](#input\_role\_policy\_json) | (optional) IAM policy to attach to role used for this task and replace defaults | `string` | `null` | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | (optional) Runtime platform for the task. Defaults to LINUX operating system family w/ CPU architecture x86\_64. | <pre>object({<br/>    operating_system_family = optional(string, "LINUX")<br/>    cpu_architecture        = optional(string, "X86_64")<br/>  })</pre> | <pre>{<br/>  "cpu_architecture": "X86_64",<br/>  "operating_system_family": "LINUX"<br/>}</pre> | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (optional) secrets to be passed to the container. By default none is passed | <pre>set(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | (optional) name of the service running this task. Only important here because the AWS console defaults to `/ecs/service_name` when displaying logs for a service | `string` | `null` | no |
| <a name="input_ssm_path"></a> [ssm\_path](#input\_ssm\_path) | (optional) path to the ssm parameters you want pulled into your container during execution of the entrypoint | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_task_execution_role_policy_json"></a> [task\_execution\_role\_policy\_json](#input\_task\_execution\_role\_policy\_json) | (optional) IAM policy to attach to task execution role used for this task and replace defaults | `string` | `null` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | (optional) task family for task. This is effectively the name of the task, without qualification of revision | `string` | `null` | no |
| <a name="input_track_latest"></a> [track\_latest](#input\_track\_latest) | (optional) Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state. | `bool` | `false` | no |
| <a name="input_use_cwagent_sidecar"></a> [use\_cwagent\_sidecar](#input\_use\_cwagent\_sidecar) | (optional) if set to true, will add a cwagent sidecar container | `bool` | `false` | no |
| <a name="input_use_xray_sidecar"></a> [use\_xray\_sidecar](#input\_use\_xray\_sidecar) | (optional) if set to null, will use the sidecar to trace the task if envoy is used, as that automatically implements tracing configs. | `bool` | `null` | no |
| <a name="input_virtual_gateway"></a> [virtual\_gateway](#input\_virtual\_gateway) | (optional) the name of the virtual gateway associated with this task definition. If null, ignored | `string` | `null` | no |
| <a name="input_virtual_node"></a> [virtual\_node](#input\_virtual\_node) | (optional) the name of the virtual node associated with this task definition. Ignored if virtual\_gateway set. If null, ignored | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Task definition ARN |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | Task definition container definitions |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM role ARN |
