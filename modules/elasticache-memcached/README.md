# PBS TF ElastiCache Memcached Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-elasticache-memcached-module?ref=2.1.0
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

Provisions an ElastiCache Memcached cluster.

Integrate this module like so:

```hcl
module "elasticache-memcached" {
  source = "github.com/pbs/terraform-aws-elasticache-memcached-module?ref=2.1.0"

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

`2.1.0`

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_elasticache_parameter_group"></a> [aws\_elasticache\_parameter\_group](#module\_aws\_elasticache\_parameter\_group) | github.com/pbs/terraform-aws-elasticache-parameter-group-module | 1.1.1 |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Whether any database modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use preferred\_availability\_zones instead. Default: System chosen Availability Zone. Changing this value will re-create the resource. | `string` | `null` | no |
| <a name="input_az_mode"></a> [az\_mode](#input\_az\_mode) | Whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num\_cache\_nodes must be greater than 1. | `string` | `"cross-az"` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of CIDR blocks to assign to the egress rule of the security group. If null, `egress_security_group_ids` must be used. | `list(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> | no |
| <a name="input_egress_source_sg_id"></a> [egress\_source\_sg\_id](#input\_egress\_source\_sg\_id) | List of security group ID to assign to the egress rule of the security group. If null, `egress_cidr_blocks` must be used. | `string` | `null` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version number of the cache engine to be used. If not set, defaults to the latest version. See Describe Cache Engine Versions in the AWS Documentation for supported versions. When engine is redis and the version is 6 or higher, the major and minor version can be set, e.g., 6.2, or the minor version can be unspecified which will use the latest version at creation time, e.g., 6.x. Otherwise, specify the full version desired, e.g., 5.0.6. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ElastiCache Memcached instance. If null, will default to product. | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | ElastiCache node type | `string` | `"cache.t3.micro"` | no |
| <a name="input_nodes"></a> [nodes](#input\_nodes) | The initial number of cache nodes that the cache cluster will have. This value must be between 1 and 40. If this number is reduced on subsequent runs, the highest numbered nodes will be removed. | `number` | `2` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | ARN of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my\_sns\_topic. | `string` | `null` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to owner | `string` | `"plops"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to be created. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number on which each of the cache nodes will accept connections. Changing this value will re-create the resource. | `number` | `11211` | no |
| <a name="input_preferred_availability_zones"></a> [preferred\_availability\_zones](#input\_preferred\_availability\_zones) | List of the Availability Zones in which cache nodes are created. If you are creating your cluster in an Amazon VPC you can only locate nodes in Availability Zones that are associated with the subnets in the selected subnet group. The number of Availability Zones listed must equal the value of num\_cache\_nodes. If you want all the nodes in the same Availability Zone, use availability\_zone instead, or repeat the Availability Zone multiple times in the list. Default: System chosen Availability Zones. Detecting drift of existing node availability zone is not currently supported. Updating this argument by itself to migrate existing node availability zones is not currently supported and will show a perpetual difference. | `list(string)` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | One or more VPC security groups associated with the nodes. If null, use the one provided by this module. | `list(string)` | `null` | no |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | Name of the security group to be created. If null, will use the name of the nodes. | `string` | `null` | no |
| <a name="input_subnet_data_lookup_filters"></a> [subnet\_data\_lookup\_filters](#input\_subnet\_data\_lookup\_filters) | Values of the `filter` blocks in the `aws_subnets` data source used in this module. If null, one will be guessed using the resolved VPC and a `Name` filter of `*-private-*`. Ignored if `subnets` is populated. | `map(any)` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the subnet group to be used for the cluster. Changing this value will re-create the resource. If null, will use the subnet group created by this module. | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to create cluster nodes in. If null, a list will be generated by looking up subnets in the resolved VPC. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Whether to use prefixes in the resource names. If false, will use a fully specified name for resources. | `bool` | `true` | no |
| <a name="input_vpc_data_lookup_tags"></a> [vpc\_data\_lookup\_tags](#input\_vpc\_data\_lookup\_tags) | Value of the `tags` parameter in the `aws_vpc` data source used in this module. If null, a dynamic lookup based on `environment` will be used. Ignored if `vpc_id` is populated. | `map(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the nodes in. If null, one will be guessed based on `vpc_data_lookup_tags`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the ElastiCache cluster |
| <a name="output_cache_nodes"></a> [cache\_nodes](#output\_cache\_nodes) | List of node objects including id, address, port and availability\_zone |
| <a name="output_cluster_address"></a> [cluster\_address](#output\_cluster\_address) | DNS name of the cache cluster without the port appended |
| <a name="output_configuration_endpoint"></a> [configuration\_endpoint](#output\_configuration\_endpoint) | Configuration endpoint to allow host discovery |
| <a name="output_name"></a> [name](#output\_name) | The name of the ElastiCache cluster |
| <a name="output_sg_ids"></a> [sg\_ids](#output\_sg\_ids) | The security group ids |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags |
