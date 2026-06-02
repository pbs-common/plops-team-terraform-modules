variable "name" {
  description = "(optional) name of the distribution. Used as the default for DNS creation when configured"
  default     = null
  type        = string
}

variable "enabled" {
  description = "(optional) enable cloudfront"
  default     = true
  type        = bool
}

variable "is_ipv6_enabled" {
  description = "(optional) enable ipv6"
  default     = true
  type        = bool
}

variable "default_root_object" {
  description = "(optional) default root object to be served from cdn. e.g. index.hml"
  default     = null
  type        = string
}

variable "cloudfront_default_certificate" {
  description = "(optional) use cloudfront default ssl certificate"
  default     = false
  type        = bool
}

variable "minimum_protocol_version" {
  description = "(optional) tls minimum protocol version"
  default     = "TLSv1.2_2021"
  type        = string
}

variable "ssl_support_method" {
  description = "(optional) ssl support method (one of vip or sni-only)"
  default     = "sni-only"
  type        = string
}

variable "default_behavior_allowed_methods" {
  description = "(optional) default behavior allowed methods"
  default     = ["GET", "HEAD"]
  type        = list(string)
}

variable "default_behavior_cached_methods" {
  description = "(optional) default behavior cached methods"
  default     = ["GET", "HEAD"]
  type        = list(string)
}

variable "default_origin_id" {
  description = "(optional) default origin origin id"
  default     = null
  type        = string
}

variable "default_behavior_lambda_function_association" {
  description = "(optional) default behavior lambda function association"
  default     = null
  type = object({
    event_type   = string
    lambda_arn   = string
    include_body = optional(bool)
  })
}

variable "default_behavior_function_association" {
  description = "(optional) default behavior function association"
  default     = null
  type = object({
    event_type   = string
    function_arn = string
  })
}

variable "viewer_protocol_policy" {
  description = "(optional) viewer protocol policy"
  default     = "redirect-to-https"
  type        = string
}

variable "compress" {
  description = "(optional) gzip compress response"
  default     = true
  type        = bool
}

variable "price_class" {
  description = "(optional) price class for the distribution"
  default     = "PriceClass_100"
  type        = string
}

variable "restriction_type" {
  description = "(optional) type of restriction for CDN"
  default     = "none"
  type        = string
}

variable "restriction_locations" {
  description = "(optional) locations to use in access restriction (whitelist or blacklist based on restriction_type)"
  default     = []
  type        = list(string)
}

variable "aliases" {
  description = "(optional) CNAME(s) that are allowed to be used for this cdn. Default is `product`.`primary_hosted_zone`. e.g. [service.example.com] --> [service.example.com]"
  default     = null
  type        = list(string)
}

variable "cnames" {
  description = "(optional) CNAME(s) that are going to be created for this cdn in the primary_hosted_zone. This can be set to [] to avoid creating a CNAME for the app. This can be useful for CDNs. Default is `product`. e.g. [service] --> [example.example.com]"
  default     = null
  type        = list(string)
}

variable "create_cname" {
  description = "(optional) create CNAME(s) that point to CloudFront distribution"
  default     = true
  type        = bool
}

variable "comment" {
  description = "(optional) comment for the CDN"
  default     = null
  type        = string
}

variable "acm_arn" {
  description = "(optional) ARN for the ACM cert used for the CloudFront distribution"
  default     = null
  type        = string
}

variable "custom_error_response" {
  description = "(optional) set of one or more custom error response elements"
  default     = []
  type        = list(any)
}

variable "logging_config" {
  description = "(optional) logging configuration that controls how logs are written to your distribution (maximum one)"
  default     = []
  type = list(object({
    logging_bucket  = string
    logging_prefix  = optional(string)
    logging_cookies = optional(bool, false)
  }))
}

variable "ordered_cache_behavior" {
  description = "(optional) an ordered list of cache behaviors resource for this distribution"
  default     = []
  type = list(object({
    path_pattern     = string
    target_origin_id = string

    cache_policy_id            = optional(string)
    origin_request_policy_id   = optional(string)
    response_headers_policy_id = optional(string)

    forwarded_values = optional(object({
      query_string            = bool
      query_string_cache_keys = optional(list(string))
      headers                 = optional(list(string))
      cookies = object({
        forward           = string
        whitelisted_names = optional(list(string))
      })
    }))

    allowed_methods           = optional(list(string), ["GET", "HEAD"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    compress                  = optional(bool, true)
    field_level_encryption_id = optional(string)
    viewer_protocol_policy    = optional(string, "redirect-to-https")
    smooth_streaming          = optional(bool)
    trusted_key_groups        = optional(list(string))
    trusted_signers           = optional(list(string))

    min_ttl     = optional(number)
    default_ttl = optional(number)
    max_ttl     = optional(number)

    lambda_function_associations = optional(list(object({
      event_type   = optional(string, "viewer-request")
      lambda_arn   = string
      include_body = optional(bool, false)
    })))
    function_associations = optional(list(object({
      event_type   = optional(string, "viewer-request")
      function_arn = string
    })))
  }))
}

variable "web_acl_id" {
  description = "(optional) unique identifier that specifies the AWS WAF web ACL"
  default     = null
  type        = string
}

variable "dns_evaluate_target_health" {
  description = "(optional) evaluate health of endpoints by querying DNS records"
  default     = false
  type        = bool
}

variable "default_forwarded_values" {
  description = "(optional) forwarded values for the default cache behavior. Use this for legacy configurations that cannot use cache policies. Mutually exclusive with default_cache_policy_id/default_cache_policy_name."
  default     = null
  type = object({
    query_string            = bool
    query_string_cache_keys = optional(list(string))
    headers                 = optional(list(string))
    cookies = object({
      forward           = string
      whitelisted_names = optional(list(string))
    })
  })
}
variable "default_min_ttl" {
  description = "(optional) minimum TTL for the default cache behavior. Only used with default_forwarded_values."
  default     = 0
  type        = number
}

variable "default_default_ttl" {
  description = "(optional) default TTL for the default cache behavior. Only used with default_forwarded_values."
  default     = 86400
  type        = number
}

variable "default_max_ttl" {
  description = "(optional) maximum TTL for the default cache behavior. Only used with default_forwarded_values."
  default     = 31536000
  type        = number
}
variable "default_cache_policy_id" {
  description = "(optional) policy id for the cache policy of the default cache behavior. If null, a lookup on default_cache_policy_name will be attempted. Ignored when default_forwarded_values is set."
  default     = null
  type        = string
}

variable "default_cache_policy_name" {
  description = "(optional) policy name for the cache policy of the default cache behavior"
  default     = "Managed-CachingDisabled"
  type        = string
}

variable "default_origin_request_policy_id" {
  description = "(optional) policy id for the origin request policy of the default cache behavior. If null, a lookup on default_origin_request_policy_name will be attempted."
  default     = null
  type        = string
}

variable "default_origin_request_policy_name" {
  description = "(optional) policy name for the origin request policy of the default cache behavior"
  default     = null
  type        = string
}

variable "default_response_headers_policy_id" {
  description = "(optional) policy id for the response headers policy of the default cache behavior. If null, a lookup on default_response_headers_policy_name will be attempted."
  default     = null
  type        = string
}

variable "default_response_headers_policy_name" {
  description = "(optional) policy name for the response headers policy of the default cache behavior"
  default     = null
  type        = string
}

variable "http_version" {
  description = "(optional) The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3."
  default     = "http2and3"
  type        = string
}

variable "v2_logging" {
  description = "(optional) enable v2 logging for the distribution"
  default     = null
  type = object({
    s3_bucket_arn               = string
    s3_prefix                   = optional(string, "cloudfront_access_logs")
    suffix_path                 = optional(string, "/{accountid}/{distributionid}/{yyyy}/{MM}/{dd}/{HH}/")
    output_format               = optional(string, "parquet")
    enable_hive_compatible_path = optional(bool, true)
    field_delimiter             = optional(string)
    record_fields               = optional(list(string))
  })
}
