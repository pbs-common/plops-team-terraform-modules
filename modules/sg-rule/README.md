# PBS TF SG Rule Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions a security group rule. Use in conjunction with other modules to modify ingress and egress rules on security groups provisioned by them.

Note that each security group rule requires an explicit description. Try to make these as descriptive as possible.

Integrate this module like so:

```hcl
module "sg_rule" {
  source = "github.com/pbs/terraform-aws-sg-rule-module?ref=1.0.1"

  security_group_id = module.redis.sg_ids[0]

  description = "Allow Lambda ${module.lambda.name} to access Redis"

  port                     = 6379
  source_security_group_id = module.lambda.sg
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
| [aws_vpc_security_group_egress_rule.egress_rule_cidrv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_rule_cidrv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.egress_rule_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_cidrv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_cidrv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_rule_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the rule. This must clearly describe the purpose of the rule. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | The ID of the security group that contains the rule. | `string` | n/a | yes |
| <a name="input_from_port"></a> [from\_port](#input\_from\_port) | The start port | `number` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port to allow. | `number` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol to allow. Valid values are tcp, udp, and all. | `string` | `"tcp"` | no |
| <a name="input_source_cidr_blocks"></a> [source\_cidr\_blocks](#input\_source\_cidr\_blocks) | A list of CIDR blocks to allow access from. | `list(string)` | `null` | no |
| <a name="input_source_ipv6_cidr_blocks"></a> [source\_ipv6\_cidr\_blocks](#input\_source\_ipv6\_cidr\_blocks) | A list of IPv6 CIDR blocks to allow access from. | `list(string)` | `null` | no |
| <a name="input_source_security_group_id"></a> [source\_security\_group\_id](#input\_source\_security\_group\_id) | The ID of the security group that is allowed access. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_to_port"></a> [to\_port](#input\_to\_port) | The end port | `number` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of rule to create. Valid values are egress, ingress, and all. | `string` | `"ingress"` | no |

## Outputs

No outputs.
