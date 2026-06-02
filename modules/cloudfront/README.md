# PBS TF CloudFront module

## Installation

### Using the Repo Source

Use this URL for the source of the module. See the usage examples below for more details.

```hcl
github.com/pbs/terraform-aws-cloudfront-module?ref=4.0.2
```

### Alternative Installation Methods

More information can be found on these install methods and more in [the documentation here](./docs/general/install).

## Usage

This module creates a CloudFront distribution.

If configured to integrate with an S3 bucket, an origin access identity will be configured for the bucket.

Integrate this module like so:

```hcl
module "cloudfront" {
  source = "github.com/pbs/terraform-aws-cloudfront-module?ref=4.0.2"

  # Required Parameters
  primary_hosted_zone = "example.com"
  origins = [{
    domain_name = module.service.domain_name
    custom_origin_config = {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }]

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

`4.0.2`

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudwatch_log_delivery.log_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery) | resource |
| [aws_cloudwatch_log_delivery_destination.delivery_destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery_destination) | resource |
| [aws_cloudwatch_log_delivery_source.delivery_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_delivery_source) | resource |
| [aws_route53_record.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.primary_acm_wildcard_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_cloudfront_cache_policy.cache_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.origin_request_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |
| [aws_cloudfront_response_headers_policy.response_headers_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
| [aws_default_tags.common_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_route53_zone.primary_hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (sharedtools, dev, staging, qa, prod) | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Organization using this module. Used to prefix tags so that they are easily identified as being from your organization | `string` | n/a | yes |
| <a name="input_origins"></a> [origins](#input\_origins) | One or more origins for this distribution. | <pre>list(object({<br/>    domain_name         = string<br/>    connection_attempts = optional(number)<br/>    connection_timeout  = optional(number)<br/>    custom_header = optional(object({<br/>      name  = string<br/>      value = string<br/>    }))<br/>    custom_origin_config = optional(object({<br/>      http_port                = optional(number)<br/>      https_port               = optional(number)<br/>      origin_keepalive_timeout = optional(number)<br/>      origin_protocol_policy   = optional(string)<br/>      origin_read_timeout      = optional(number)<br/>      origin_ssl_protocols     = optional(list(string))<br/>    }))<br/>    origin_path      = optional(string)<br/>    origin_id        = optional(string)<br/>    s3_origin_config = optional(string)<br/>    origin_shield = optional(object({<br/>      enabled              = optional(bool)<br/>      origin_shield_region = optional(string)<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_primary_hosted_zone"></a> [primary\_hosted\_zone](#input\_primary\_hosted\_zone) | Name of the primary hosted zone for DNS. e.g. primary\_hosted\_zone = example.org --> service.example.org. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Tag used to group resources according to product | `string` | n/a | yes |
| <a name="input_repo"></a> [repo](#input\_repo) | Tag used to point to the repo using this module | `string` | n/a | yes |
| <a name="input_acm_arn"></a> [acm\_arn](#input\_acm\_arn) | (optional) ARN for the ACM cert used for the CloudFront distribution | `string` | `null` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | (optional) CNAME(s) that are allowed to be used for this cdn. Default is `product`.`primary_hosted_zone`. e.g. [service.example.com] --> [service.example.com] | `list(string)` | `null` | no |
| <a name="input_cloudfront_default_certificate"></a> [cloudfront\_default\_certificate](#input\_cloudfront\_default\_certificate) | (optional) use cloudfront default ssl certificate | `bool` | `false` | no |
| <a name="input_cnames"></a> [cnames](#input\_cnames) | (optional) CNAME(s) that are going to be created for this cdn in the primary\_hosted\_zone. This can be set to [] to avoid creating a CNAME for the app. This can be useful for CDNs. Default is `product`. e.g. [service] --> [example.example.com] | `list(string)` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | (optional) comment for the CDN | `string` | `null` | no |
| <a name="input_compress"></a> [compress](#input\_compress) | (optional) gzip compress response | `bool` | `true` | no |
| <a name="input_create_cname"></a> [create\_cname](#input\_create\_cname) | (optional) create CNAME(s) that point to CloudFront distribution | `bool` | `true` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | (optional) set of one or more custom error response elements | `list(any)` | `[]` | no |
| <a name="input_default_behavior_allowed_methods"></a> [default\_behavior\_allowed\_methods](#input\_default\_behavior\_allowed\_methods) | (optional) default behavior allowed methods | `list(string)` | <pre>[<br/>  "GET",<br/>  "HEAD"<br/>]</pre> | no |
| <a name="input_default_behavior_cached_methods"></a> [default\_behavior\_cached\_methods](#input\_default\_behavior\_cached\_methods) | (optional) default behavior cached methods | `list(string)` | <pre>[<br/>  "GET",<br/>  "HEAD"<br/>]</pre> | no |
| <a name="input_default_behavior_function_association"></a> [default\_behavior\_function\_association](#input\_default\_behavior\_function\_association) | (optional) default behavior function association | <pre>object({<br/>    event_type   = string<br/>    function_arn = string<br/>  })</pre> | `null` | no |
| <a name="input_default_behavior_lambda_function_association"></a> [default\_behavior\_lambda\_function\_association](#input\_default\_behavior\_lambda\_function\_association) | (optional) default behavior lambda function association | <pre>object({<br/>    event_type   = string<br/>    lambda_arn   = string<br/>    include_body = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_default_cache_policy_id"></a> [default\_cache\_policy\_id](#input\_default\_cache\_policy\_id) | (optional) policy id for the cache policy of the default cache behavior. If null, a lookup on default\_cache\_policy\_name will be attempted. Ignored when default\_forwarded\_values is set. | `string` | `null` | no |
| <a name="input_default_cache_policy_name"></a> [default\_cache\_policy\_name](#input\_default\_cache\_policy\_name) | (optional) policy name for the cache policy of the default cache behavior | `string` | `"Managed-CachingDisabled"` | no |
| <a name="input_default_default_ttl"></a> [default\_default\_ttl](#input\_default\_default\_ttl) | (optional) default TTL for the default cache behavior. Only used with default\_forwarded\_values. | `number` | `86400` | no |
| <a name="input_default_forwarded_values"></a> [default\_forwarded\_values](#input\_default\_forwarded\_values) | (optional) forwarded values for the default cache behavior. Use this for legacy configurations that cannot use cache policies. Mutually exclusive with default\_cache\_policy\_id/default\_cache\_policy\_name. | <pre>object({<br/>    query_string            = bool<br/>    query_string_cache_keys = optional(list(string))<br/>    headers                 = optional(list(string))<br/>    cookies = object({<br/>      forward           = string<br/>      whitelisted_names = optional(list(string))<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_default_max_ttl"></a> [default\_max\_ttl](#input\_default\_max\_ttl) | (optional) maximum TTL for the default cache behavior. Only used with default\_forwarded\_values. | `number` | `31536000` | no |
| <a name="input_default_min_ttl"></a> [default\_min\_ttl](#input\_default\_min\_ttl) | (optional) minimum TTL for the default cache behavior. Only used with default\_forwarded\_values. | `number` | `0` | no |
| <a name="input_default_origin_id"></a> [default\_origin\_id](#input\_default\_origin\_id) | (optional) default origin origin id | `string` | `null` | no |
| <a name="input_default_origin_request_policy_id"></a> [default\_origin\_request\_policy\_id](#input\_default\_origin\_request\_policy\_id) | (optional) policy id for the origin request policy of the default cache behavior. If null, a lookup on default\_origin\_request\_policy\_name will be attempted. | `string` | `null` | no |
| <a name="input_default_origin_request_policy_name"></a> [default\_origin\_request\_policy\_name](#input\_default\_origin\_request\_policy\_name) | (optional) policy name for the origin request policy of the default cache behavior | `string` | `null` | no |
| <a name="input_default_response_headers_policy_id"></a> [default\_response\_headers\_policy\_id](#input\_default\_response\_headers\_policy\_id) | (optional) policy id for the response headers policy of the default cache behavior. If null, a lookup on default\_response\_headers\_policy\_name will be attempted. | `string` | `null` | no |
| <a name="input_default_response_headers_policy_name"></a> [default\_response\_headers\_policy\_name](#input\_default\_response\_headers\_policy\_name) | (optional) policy name for the response headers policy of the default cache behavior | `string` | `null` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | (optional) default root object to be served from cdn. e.g. index.hml | `string` | `null` | no |
| <a name="input_dns_evaluate_target_health"></a> [dns\_evaluate\_target\_health](#input\_dns\_evaluate\_target\_health) | (optional) evaluate health of endpoints by querying DNS records | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (optional) enable cloudfront | `bool` | `true` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | (optional) The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. | `string` | `"http2and3"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | (optional) enable ipv6 | `bool` | `true` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | (optional) logging configuration that controls how logs are written to your distribution (maximum one) | <pre>list(object({<br/>    logging_bucket  = string<br/>    logging_prefix  = optional(string)<br/>    logging_cookies = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | (optional) tls minimum protocol version | `string` | `"TLSv1.2_2021"` | no |
| <a name="input_name"></a> [name](#input\_name) | (optional) name of the distribution. Used as the default for DNS creation when configured | `string` | `null` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | (optional) an ordered list of cache behaviors resource for this distribution | <pre>list(object({<br/>    path_pattern     = string<br/>    target_origin_id = string<br/><br/>    cache_policy_id            = optional(string)<br/>    origin_request_policy_id   = optional(string)<br/>    response_headers_policy_id = optional(string)<br/><br/>    forwarded_values = optional(object({<br/>      query_string            = bool<br/>      query_string_cache_keys = optional(list(string))<br/>      headers                 = optional(list(string))<br/>      cookies = object({<br/>        forward           = string<br/>        whitelisted_names = optional(list(string))<br/>      })<br/>    }))<br/><br/>    allowed_methods           = optional(list(string), ["GET", "HEAD"])<br/>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br/>    compress                  = optional(bool, true)<br/>    field_level_encryption_id = optional(string)<br/>    viewer_protocol_policy    = optional(string, "redirect-to-https")<br/>    smooth_streaming          = optional(bool)<br/>    trusted_key_groups        = optional(list(string))<br/>    trusted_signers           = optional(list(string))<br/><br/>    min_ttl     = optional(number)<br/>    default_ttl = optional(number)<br/>    max_ttl     = optional(number)<br/><br/>    lambda_function_associations = optional(list(object({<br/>      event_type   = optional(string, "viewer-request")<br/>      lambda_arn   = string<br/>      include_body = optional(bool, false)<br/>    })))<br/>    function_associations = optional(list(object({<br/>      event_type   = optional(string, "viewer-request")<br/>      function_arn = string<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | (optional) price class for the distribution | `string` | `"PriceClass_100"` | no |
| <a name="input_restriction_locations"></a> [restriction\_locations](#input\_restriction\_locations) | (optional) locations to use in access restriction (whitelist or blacklist based on restriction\_type) | `list(string)` | `[]` | no |
| <a name="input_restriction_type"></a> [restriction\_type](#input\_restriction\_type) | (optional) type of restriction for CDN | `string` | `"none"` | no |
| <a name="input_ssl_support_method"></a> [ssl\_support\_method](#input\_ssl\_support\_method) | (optional) ssl support method (one of vip or sni-only) | `string` | `"sni-only"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags | `map(string)` | `{}` | no |
| <a name="input_v2_logging"></a> [v2\_logging](#input\_v2\_logging) | (optional) enable v2 logging for the distribution | <pre>object({<br/>    s3_bucket_arn               = string<br/>    s3_prefix                   = optional(string, "cloudfront_access_logs")<br/>    suffix_path                 = optional(string, "/{accountid}/{distributionid}/{yyyy}/{MM}/{dd}/{HH}/")<br/>    output_format               = optional(string, "parquet")<br/>    enable_hive_compatible_path = optional(bool, true)<br/>    field_delimiter             = optional(string)<br/>    record_fields               = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | (optional) viewer protocol policy | `string` | `"redirect-to-https"` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | (optional) unique identifier that specifies the AWS WAF web ACL | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the CloudFront distribution |
| <a name="output_default_cache_policy_id"></a> [default\_cache\_policy\_id](#output\_default\_cache\_policy\_id) | The default cache policy ID |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | One domain name that will resolve to this cdn. Might not be a valid alias. |
| <a name="output_id"></a> [id](#output\_id) | ID of the CloudFront distribution |
| <a name="output_oac_id"></a> [oac\_id](#output\_oac\_id) | ID of the origin access identity |
