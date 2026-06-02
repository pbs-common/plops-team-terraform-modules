data "aws_route53_zone" "primary_hosted_zone" {
  name = "${var.primary_hosted_zone}."
}

data "aws_acm_certificate" "primary_acm_wildcard_cert" {
  count  = var.acm_arn != null ? 0 : 1
  domain = "*.${var.primary_hosted_zone}"
}

data "aws_cloudfront_cache_policy" "cache_policy" {
  count = local.lookup_default_cache_policy_id ? 1 : 0
  name  = var.default_cache_policy_name
}

data "aws_cloudfront_origin_request_policy" "origin_request_policy" {
  count = local.lookup_default_origin_request_policy_id ? 1 : 0
  name  = var.default_origin_request_policy_name
}

data "aws_cloudfront_response_headers_policy" "response_headers_policy" {
  count = local.lookup_default_response_headers_policy_id ? 1 : 0
  name  = var.default_response_headers_policy_name
}
