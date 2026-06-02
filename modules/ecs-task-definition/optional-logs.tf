variable "service_name" {
  description = "(optional) name of the service running this task. Only important here because the AWS console defaults to `/ecs/service_name` when displaying logs for a service"
  default     = null
  type        = string
}

variable "log_group_name" {
  description = "(optional) name for the log group"
  default     = null
  type        = string
}

variable "log_group_class" {
  description = "(Optional) log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  default     = "INFREQUENT_ACCESS"
  type        = string
}

variable "retention_in_days" {
  description = "(optional) log retention in days"
  default     = 7
  type        = number
}

variable "awslogs_driver_mode" {
  description = "(optional) awslogs driver mode. Set this to `blocking` if you would rather have an outage than lose logs."
  default     = "non-blocking"
  type        = string
}
