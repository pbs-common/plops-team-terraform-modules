locals {
  name                   = var.name != null ? var.name : var.product
  cnames                 = var.cnames != null ? var.cnames : [local.name]
  aliases                = var.aliases != null ? var.aliases : ["${local.name}.${var.primary_hosted_zone}"]
  comment                = var.comment != null ? var.comment : "${local.aliases[0]} CDN."
  primary_hosted_zone_id = data.aws_route53_zone.primary_hosted_zone.zone_id
  acm_arn                = var.acm_arn != null ? var.acm_arn : data.aws_acm_certificate.primary_acm_wildcard_cert[0].arn

  # The following try is a workaround to prevent errors during destroy
  domain_name = var.create_cname && length(local.cnames) > 0 ? try(aws_route53_record.dns[0].fqdn, null) : aws_cloudfront_distribution.cdn.domain_name

  default_origin_id = var.default_origin_id != null ? var.default_origin_id : var.origins[0].origin_id != null ? var.origins[0].origin_id : var.origins[0].domain_name

  origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

  # Default cache behavior policies
  use_default_forwarded_values                = var.default_forwarded_values != null
  lookup_default_cache_policy_id            = var.default_cache_policy_id == null && !local.use_default_forwarded_values
  default_cache_policy_id                   = local.use_default_forwarded_values ? null : var.default_cache_policy_id != null ? var.default_cache_policy_id : data.aws_cloudfront_cache_policy.cache_policy[0].id
  lookup_default_origin_request_policy_id   = var.default_origin_request_policy_id == null && var.default_origin_request_policy_name != null
  default_origin_request_policy_id          = local.use_default_forwarded_values ? null : var.default_origin_request_policy_id != null ? var.default_origin_request_policy_id : local.lookup_default_origin_request_policy_id ? data.aws_cloudfront_origin_request_policy.origin_request_policy[0].id : null
  lookup_default_response_headers_policy_id = var.default_origin_request_policy_id == null && var.default_response_headers_policy_name != null
  default_response_headers_policy_id        = var.default_response_headers_policy_id != null ? var.default_response_headers_policy_id : local.lookup_default_response_headers_policy_id ? data.aws_cloudfront_response_headers_policy.response_headers_policy[0].id : null

  creator = "terraform"

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )

  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })

  default_record_fields = [
    "date",
    "time",
    "timestamp",
    "x-edge-location",
    "sc-bytes",
    "c-ip",
    "cs-method",
    "cs(Host)",
    "cs-uri-stem",
    "sc-status",
    "cs(Referer)",
    "cs(User-Agent)",
    "cs-uri-query",
    "cs(Cookie)",
    "x-edge-result-type",
    "x-edge-request-id",
    "x-host-header",
    "cs-protocol",
    "cs-bytes",
    "time-taken",
    "x-forwarded-for",
    "ssl-protocol",
    "x-edge-response-result-type",
    "cs-protocol-version",
    "fle-status",
    "fle-encrypted-fields",
    "c-port",
    "time-to-first-byte",
    "x-edge-detailed-result-type",
    "sc-content-type",
    "sc-content-len",
    "sc-range-start",
    "sc-range-end",
    "ssl-cipher"
  ]

  merged_record_fields = distinct(
    concat(local.default_record_fields,
      coalesce(var.v2_logging != null ? var.v2_logging.record_fields : [], [])
  ))
}

data "aws_default_tags" "common_tags" {}
