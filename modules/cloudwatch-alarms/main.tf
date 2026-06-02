resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = local.name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  alarm_description   = local.alarm_description

  datapoints_to_alarm = var.datapoints_to_alarm
  treat_missing_data  = var.treat_missing_data

  alarm_actions = local.alarm_actions

  namespace   = local.alarm_namespace
  period      = local.alarm_period
  statistic   = local.alarm_statistic
  metric_name = local.alarm_metric_name
  dimensions  = local.alarm_dimensions

  # Error Rate Metrics

  dynamic "metric_query" {
    for_each = local.is_error_rate_alarm ? [local.is_error_rate_alarm] : []
    content {
      id = "errors"
      metric {
        metric_name = local.errors_metric
        namespace   = var.namespace
        period      = var.period
        stat        = var.statistic
        dimensions  = local.dimensions
      }
    }
  }

  dynamic "metric_query" {
    for_each = local.is_error_rate_alarm ? [local.is_error_rate_alarm] : []
    content {
      id = "total"
      metric {
        metric_name = local.total_metric
        namespace   = var.namespace
        period      = var.period
        stat        = var.statistic
        dimensions  = local.dimensions
      }
    }
  }

  dynamic "metric_query" {
    for_each = local.is_error_rate_alarm ? [local.is_error_rate_alarm] : []
    content {
      id = "errorRate"

      expression  = "( errors / total ) * 100"
      label       = "Error rate percentage"
      return_data = "true"
    }
  }

  # Growth Rate Metrics

  dynamic "metric_query" {
    for_each = local.is_growth_alarm ? [local.is_growth_alarm] : []
    content {
      id = "growth"
      metric {
        metric_name = local.growth_metric
        namespace   = var.namespace
        period      = var.period
        stat        = var.statistic
        dimensions  = local.dimensions
      }
    }
  }

  dynamic "metric_query" {
    for_each = local.is_growth_alarm ? [local.is_growth_alarm] : []
    content {
      id = "consumption"
      metric {
        metric_name = local.consumption_metric
        namespace   = var.namespace
        period      = var.period
        stat        = var.statistic
        dimensions  = local.dimensions
      }
    }
  }

  dynamic "metric_query" {
    for_each = local.is_growth_alarm ? [local.is_growth_alarm] : []
    content {
      id = "netGrowthRate"

      expression  = "growth - consumption"
      label       = "Net growth rate"
      return_data = "true"
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_metric_filter" "filter" {
  count          = var.log_metric_filter != null ? 1 : 0
  name           = var.log_metric_filter.name
  pattern        = var.log_metric_filter.pattern
  log_group_name = var.log_metric_filter.log_group_name

  metric_transformation {
    default_value = var.log_metric_filter.default_value
    name          = local.metric_name
    namespace     = var.namespace
    value         = var.log_metric_filter.value
  }
}
