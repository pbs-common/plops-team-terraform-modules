# PBS TF S3 Module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-s3-module?ref=5.0.2
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions an S3 bucket.

The bucket will be `AES256` encrypted, without the option to adjust that.

By default, the bucket will be versioned. This can be adjusted by using the `is_versioned` parameter.

If your use case requires adjusting the CORS configuration of the bucket, that is exposed through the `cors_rules` parameter.

Integrate this module like so:

```hcl
module "s3" {
  source = "github.com/pbs/terraform-aws-s3-module?ref=5.0.2"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
}
```

It is highly recommended that you integrate an inventory prefix when using this module.

Do this like so:

```hcl
module "s3" {
  source  = "../modules/s3"

  # Tagging Parameters
  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo

  # Optional Parameters
  inventory_bucket = var.inventory_bucket
}
```

## Adding This Version of the Module

If this repo is added as a subtree, then the version of the module should be close to the version shown here:

`5.0.2`

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
| <a name="module_s3_policy"></a> [s3\_policy](#module\_s3\_policy) | github.com/pbs/terraform-aws-s3-bucket-policy-module | 2.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.replication_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_inventory.inventory_prefix](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy_document.s3_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_acl"></a> [acl](#input\_acl) | ACL configuration for the bucket. If an ACL is not provided, the bucket will be created with ACLs disabled | <pre>object({<br/>    canned_acl            = optional(string)<br/>    expected_bucket_owner = optional(string)<br/>    access_control_policy = optional(object({<br/>      grants = set(object({<br/>        grantee = object({<br/>          type          = string<br/>          email_address = optional(string)<br/>          id            = optional(string)<br/>          uri           = optional(string)<br/>        })<br/>        permission = string<br/>      }))<br/>      owner = object({<br/>        id           = string<br/>        display_name = optional(string)<br/>      })<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_allow_anonymous_vpce_access"></a> [allow\_anonymous\_vpce\_access](#input\_allow\_anonymous\_vpce\_access) | Create bucket policy that allows anonymous VPCE access. | `bool` | `false` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Policy to apply to the bucket. If null, one will be guessed based on other variables. | `string` | `null` | no |
| <a name="input_cloudfront_oac_access_statements"></a> [cloudfront\_oac\_access\_statements](#input\_cloudfront\_oac\_access\_statements) | List of objects that define the CloudFront origin access identity access statement. Each object must have a `cloudfront_arn` and `path` key. | <pre>list(object({<br/>    cloudfront_arn = string<br/>    path           = optional(string, "*")<br/>  }))</pre> | `[]` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | CORS Rules | <pre>set(object({<br/>    allowed_headers = list(string),<br/>    allowed_methods = list(string),<br/>    allowed_origins = list(string),<br/>    expose_headers  = list(string),<br/>    max_age_seconds = number<br/>  }))</pre> | `[]` | no |
| <a name="input_create_bucket_policy"></a> [create\_bucket\_policy](#input\_create\_bucket\_policy) | Create a bucket policy for the bucket | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destruction of an S3 bucket without clearing out the contents first | `bool` | `false` | no |
| <a name="input_force_tls"></a> [force\_tls](#input\_force\_tls) | Deny HTTP requests that are made to the bucket without TLS. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_inventory_config"></a> [inventory\_config](#input\_inventory\_config) | Inventory configuration | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    included_object_versions = optional(string, "All")<br/>    destination = object({<br/>      bucket = object({<br/>        name       = string<br/>        format     = optional(string, "Parquet")<br/>        prefix     = optional(string)<br/>        account_id = optional(string)<br/>      })<br/>    })<br/>    filter = optional(object({<br/>      prefix = string<br/>    }))<br/>    schedule = optional(object({<br/>      frequency = string<br/>      }), {<br/>      frequency = "Daily"<br/>    })<br/>    optional_fields = optional(list(string), [<br/>      "Size",<br/>      "LastModifiedDate",<br/>      "StorageClass",<br/>      "IntelligentTieringAccessTier",<br/>    ])<br/>  })</pre> | `null` | no |
| <a name="input_is_versioned"></a> [is\_versioned](#input\_is\_versioned) | Is versioning enabled? | `bool` | `true` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management. | <pre>list(object({<br/>    id      = string<br/>    enabled = optional(bool, true)<br/>    filter = optional(object({<br/>      and = optional(list(object({<br/>        object_size_greater_than = optional(number)<br/>        object_size_less_than    = optional(number)<br/>        prefix                   = optional(string)<br/>        tags                     = optional(map(string))<br/>      })))<br/>      object_size_greater_than = optional(number)<br/>      object_size_less_than    = optional(number)<br/>      prefix                   = optional(string)<br/>      tag = optional(object({<br/>        key   = string<br/>        value = string<br/>      }))<br/>    }), {})<br/>    abort_incomplete_multipart_upload_days = optional(number)<br/>    expiration = optional(object({<br/>      date                         = optional(string)<br/>      days                         = optional(number)<br/>      expired_object_delete_marker = optional(bool)<br/>    }))<br/>    noncurrent_version_expiration = optional(object({<br/>      days = optional(number)<br/>    }))<br/>    noncurrent_version_transition = optional(list(object({<br/>      days          = optional(number)<br/>      storage_class = optional(string)<br/>    })), [])<br/>    transition = optional(list(object({<br/>      date          = optional(string)<br/>      days          = optional(number)<br/>      storage_class = string<br/>    })), [])<br/>  }))</pre> | <pre>[<br/>  {<br/>    "abort_incomplete_multipart_upload_days": 7,<br/>    "enabled": true,<br/>    "id": "default-lifecycle-rule",<br/>    "noncurrent_version_transition": [<br/>      {<br/>        "days": 30,<br/>        "storage_class": "GLACIER"<br/>      }<br/>    ],<br/>    "transition": [<br/>      {<br/>        "days": 7,<br/>        "storage_class": "INTELLIGENT_TIERING"<br/>      }<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use for the bucket. If null, will default to product. | `string` | `null` | no |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank sids will override statements with the same sid from earlier documents in the list. Statements with non-blank sids will also override statements with the same sid from documents provided in the source\_json and source\_policy\_documents arguments. Non-overriding statements will be added to the exported document. | `list(string)` | `null` | no |
| <a name="input_replication_configuration_set"></a> [replication\_configuration\_set](#input\_replication\_configuration\_set) | Set of (single) replication that needs to be managed by this bucket. If empty, no replication takes place. | <pre>set(object({<br/>    role = string,<br/>    rules = set(object({<br/>      id                                           = string<br/>      priority                                     = number<br/>      status                                       = string<br/>      destination_account_id                       = string<br/>      destination_bucket                           = string<br/>      destination_access_control_translation_owner = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_replication_configuration_shortcut"></a> [replication\_configuration\_shortcut](#input\_replication\_configuration\_shortcut) | Shorthand version of the configuration used in replication\_configuration\_set. Is overridden by replication\_configuration\_set if defined. | <pre>object({<br/>    destination_account_id = string<br/>    destination_bucket     = string<br/>  })</pre> | `null` | no |
| <a name="input_replication_source"></a> [replication\_source](#input\_replication\_source) | The account number and role for the source bucket in a replication configuration. | <pre>object({<br/>    account_id = string<br/>    role       = string<br/>  })</pre> | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_source_policy_documents"></a> [source\_policy\_documents](#input\_source\_policy\_documents) | List of IAM policy documents that are merged together into the exported document. Statements defined in source\_policy\_documents or source\_json must have unique sids. Statements with the same sid from documents assigned to the override\_json and override\_policy\_documents arguments will override source statements. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Create bucket with prefix instead of explicit name | `bool` | `true` | no |
| <a name="input_vpce"></a> [vpce](#input\_vpce) | Name of the VPC endpoint that should have access to this bucket. Only used when `allow_anonymous_vpce_access` is true. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the bucket |
| <a name="output_name"></a> [name](#output\_name) | Name of the bucket |
| <a name="output_regional_domain_name"></a> [regional\_domain\_name](#output\_regional\_domain\_name) | Regional domain name |
| <a name="output_replication_role"></a> [replication\_role](#output\_replication\_role) | Replication role if exists |
