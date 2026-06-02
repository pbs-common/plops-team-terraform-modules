variable "name" {
  description = "Name for the Cloud Watch Event Rule"
  default     = null
  type        = string
}

variable "description" {
  description = "Description for the Cloud Watch Event Rule"
  default     = null
  type        = string
}

variable "targets" {
  description = "Map of targets for the CloudWatch event rule. e.g. { \"example_target_id\" = { arn = \"example_lambda_arn\", role_arn = \"example_event_role_arn\" } }"
  default     = {}
  type        = map(any)
}

variable "lambda_permissions" {
  description = "Map of lambda permissions for the CloudWatch event rule. e.g. { \"example_statement_id_prefix\" = \"example_lambda_arn\" }"
  default     = {}
  type        = map(any)
}
