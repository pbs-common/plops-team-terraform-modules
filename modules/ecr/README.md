# PBS TF ECR Module

## Installation

### Using the Repo Source

```hcl
github.com/pbs/terraform-aws-ecr-module?ref=1.0.1
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module provisions an ECR repository.

By default, the repository will be created with
- sharedtools: 5 images  
- dev: 10 images         
- qa: 15 images          
- staging: 20 images    
- prod: 35 images
 retention policy, be `AES256` encrypted and allow access from Lambda. Use the optional variables provided in this module to adjust those configurations.

Integrate this module like so:

```hcl
module "ecr" {
  source = "github.com/pbs/terraform-aws-ecr-module?ref=1.0.1"

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
| [aws_ecr_lifecycle_policy.repo_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, qa, staging, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_allow_lambda_access"></a> [allow\_lambda\_access](#input\_allow\_lambda\_access) | (optional) Allow Lambda access to ECR | `bool` | `true` | no |
| <a name="input_create_ecr_policy"></a> [create\_ecr\_policy](#input\_create\_ecr\_policy) | (optional) Create ECR policy | `bool` | `true` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | (optional) Encryption configuration. Set `encryption_type` to `KMS` to use KMS encryption. Set `kms_key_arn` to the ARN of the KMS key to use. Set `encryption_type` to `AES256` to use AES256 encryption. | <pre>object({<br/>    encryption_type = string<br/>    kms_key_arn     = optional(string)<br/>  })</pre> | <pre>{<br/>  "encryption_type": "AES256",<br/>  "kms_key_arn": null<br/>}</pre> | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | (optional) Force delete ECR repository even if it has images in it | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | (optional) Image tag mutability (allowance for a tag be reassigned to another image) | `string` | `"IMMUTABLE"` | no |
| <a name="input_images_to_retain"></a> [images\_to\_retain](#input\_images\_to\_retain) | (optional) Number of most recent images to retain (set to null for no retention policy) | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (optional) Name of the ECR repository (defaults to product if null) | `string` | `null` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | (optional) Security scan on push | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repo_url"></a> [repo\_url](#output\_repo\_url) | URL for the repository |
