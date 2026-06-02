variable "name" {
  description = "Name of the alarm being created. Defaults to product if null."
  default     = null
  type        = string
}

variable "alarm_description" {
  description = "Description of the alarm being created. Defaults to Alarm for {local.name} Errors (High) if null."
  default     = null
  type        = string
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. Additionally, the values LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, and GreaterThanUpperThreshold are used only for alarms based on anomaly detection models."
  default     = "GreaterThanOrEqualToThreshold"
  type        = string
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 1
  type        = number
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  default     = 60
  type        = number
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Any of the following are supported: SampleCount, Average, Sum, Minimum, Maximum."
  default     = "Sum"
  type        = string
  validation {
    condition = contains([
      "SampleCount",
      "Average",
      "Sum",
      "Minimum",
      "Maximum",
    ], var.statistic)
    error_message = "Statistic is not currently supported by this module."
  }
}

variable "threshold" {
  description = "The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
  default     = null
  type        = string
}

variable "datapoints_to_alarm" {
  description = "Datapoints to alarm."
  default     = 1
  type        = number
}

variable "sns_arn" {
  description = "SNS topic ARN associated with Lambda that handles payload delivery."
  default     = null
  type        = string
  validation {
    condition     = var.sns_arn == null || can(regex("^arn:aws:sns:[a-z0-9\\-]+:[0-9]+:[a-zA-Z0-9\\-_]+", var.sns_arn))
    error_message = "SNS ARN must be null or a valid SNS ARN."
  }
}

variable "treat_missing_data" {
  description = "How to treat data that is missing."
  default     = "notBreaching"
  type        = string
}

variable "metric_name" {
  description = "Metric to use for this alarm."
  default     = null
  type        = string
}

variable "alarm_actions" {
  description = "Actions to take when the CloudWatch Alarm fires."
  type        = set(string)
  default     = null
}
