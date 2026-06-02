variable "primary_hosted_zone" {
  description = "Name of the primary hosted zone for DNS. e.g. primary_hosted_zone = example.org --> service.example.org."
  type        = string
}

variable "origins" {
  description = "One or more origins for this distribution."
  type = list(object({
    domain_name         = string
    connection_attempts = optional(number)
    connection_timeout  = optional(number)
    custom_header = optional(object({
      name  = string
      value = string
    }))
    custom_origin_config = optional(object({
      http_port                = optional(number)
      https_port               = optional(number)
      origin_keepalive_timeout = optional(number)
      origin_protocol_policy   = optional(string)
      origin_read_timeout      = optional(number)
      origin_ssl_protocols     = optional(list(string))
    }))
    origin_path      = optional(string)
    origin_id        = optional(string)
    s3_origin_config = optional(string)
    origin_shield = optional(object({
      enabled              = optional(bool)
      origin_shield_region = optional(string)
    }))
  }))
}
