variable "alarm_config" {
  description = "Configurations for the alarm"
  type = object({
    actions_enabled           = optional(bool, true)
    comparison_operator       = optional(string, "LessThanThreshold")
    period                    = optional(number, 300)
    evaluation_periods        = optional(number, 1)
    metric_name               = optional(string, "SuccessPercent")
    namespace                 = optional(string, "CloudWatchSynthetics")
    statistic                 = optional(string, "Sum")
    datapoints_to_alarm       = optional(number, 1)
    threshold                 = optional(string, "90")
    alarm_actions             = optional(list(string), [])
    ok_actions                = optional(list(string), [])
    insufficient_data_actions = optional(list(string), [])
    treat_missing_data        = optional(string, "missing")
    description               = optional(string)
  })
  default = {
    actions_enabled           = true
    comparison_operator       = "LessThanThreshold"
    period                    = 300
    evaluation_periods        = 1
    metric_name               = "SuccessPercent"
    namespace                 = "CloudWatchSynthetics"
    statistic                 = "Sum"
    datapoints_to_alarm       = 1
    threshold                 = "90"
    alarm_actions             = []
    ok_actions                = []
    insufficient_data_actions = []
    treat_missing_data        = "missing"
    description               = null
  }
}
