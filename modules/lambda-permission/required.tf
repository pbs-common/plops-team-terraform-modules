variable "statement_id" {
  description = "Statement ID for the Lambda Permission"
  type        = string
}

variable "action" {
  description = "Action for the Lambda Permission"
  type        = string
}

variable "function_name" {
  description = "Function Name for the Lambda Permission"
  type        = string
}

variable "principal" {
  description = "Principal for the Lambda Permission"
  type        = string
}

variable "source_arn" {
  description = "Source ARN for the Lambda Permission"
  type        = string
}
