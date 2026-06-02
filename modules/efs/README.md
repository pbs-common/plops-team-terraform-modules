# PBS TF EFS module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-efs-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This creates an EFS file system.

Integrate this module like so:

```hcl
module "efs" {
  source = "github.com/pbs/terraform-aws-efs-module?ref=1.0.1"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
  is_encrypted = true
  kms_key_id = "123-456-789"
  lifecycle_policy = "AFTER_7_DAYS"
  performance_mode = "generalPurpose"
  provisioned_throughput_in_mibps = "10000"
  subnets = ["subnet-1", "subnet-2", "subnet-3", "subnet-4"]
  security_groups = ["sg-123"]
  vpc_id = "vpc-123"
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
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_backup_policy"></a> [backup\_policy](#input\_backup\_policy) | The backup policy to use for the EFS file system. Valid values: ENABLED, DISABLED. | `string` | `"ENABLED"` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | The creation token used for the EFS file system | `string` | `null` | no |
| <a name="input_is_encrypted"></a> [is\_encrypted](#input\_is\_encrypted) | Boolean indicating if the EFS should be encrypted or not. Default is true | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ID for the KMS key to use for encryption. | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | The lifecycle policy to use for transition EFS objects to infrequent access (IA) storage. Default: AFTER\_30\_DAYS. Valid values: NONE, AFTER\_7\_DAYS, AFTER\_14\_DAYS, AFTER\_30\_DAYS, AFTER\_60\_DAYS, AFTER\_90\_DAYS. | `string` | `"AFTER_30_DAYS"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS file system. If null, will default to product. | `string` | `null` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The performance mode for the EFS. Can be either generalPurpose or maxIO. Default is generalPurpose | `string` | `"generalPurpose"` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | Setting this variable changes the EFS performance mode from bursting to provisioned, and sets the provisioned\_throughput\_in\_mibps setting for the EFS. If 0, the performance mode will be bursting. | `string` | `0` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs that will be applied to the EFS managing access. | `list(any)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnet IDs where the app will be mounted. Must all be from the same VPC | `list(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to build the EFS in. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | EFS ARN |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | EFS DNS name |
| <a name="output_id"></a> [id](#output\_id) | EFS ID |
| <a name="output_sgs"></a> [sgs](#output\_sgs) | Security groups |
