variable "newrelic_secret_arn" {
  description = "ARN for AWS Secrets Manager secret of New Relic Insights insert key."
  default     = null
  type        = string
}

variable "newrelic_secret_name" {
  description = "Name for AWS Secrets Manager secret of New Relic Insights insert key."
  default     = null
  type        = string
}

variable "newrelic_firelens_image" {
  description = "Name for AWS Secrets Manager secret of New Relic Insights insert key."
  default     = "533243300146.dkr.ecr.us-east-1.amazonaws.com/newrelic/logging-firelens-fluentbit"
  type        = string
}
