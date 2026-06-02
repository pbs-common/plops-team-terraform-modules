locals {
  name              = var.name != null ? var.name : var.product
  alarm_description = var.alarm_description != null ? var.alarm_description : "Alarm for ${local.name}"

  creator = "terraform"

  state_machine_dimension = var.state_machine_arn != null ? {
    StateMachineArn = var.state_machine_arn
  } : {}

  lambda_function_dimension = var.lambda_function != null ? {
    FunctionName = var.lambda_function
  } : {}

  kinesis_stream_dimension = var.kinesis_stream != null ? {
    StreamName = var.kinesis_stream
  } : {}

  mediatailor_configuration_dimension = var.mediatailor_configuration_name != null ? {
    ConfigurationName = var.mediatailor_configuration_name
  } : {}

  dimensions = merge(
    local.state_machine_dimension,
    local.lambda_function_dimension,
    local.kinesis_stream_dimension,
    local.mediatailor_configuration_dimension,
  )

  alarm_actions = var.alarm_actions != null ? var.alarm_actions : var.sns_arn != null ? [var.sns_arn] : null

  use_metric_query = !local.is_error_rate_alarm && !local.is_growth_alarm

  is_error_rate_alarm = var.lambda_function != null || var.kinesis_stream != null
  is_growth_alarm     = var.queue_name != null

  metric_name = var.metric_name != null ? var.metric_name : var.state_machine_arn != null ? "ExecutionsFailed" : null

  errors_metric = var.lambda_function != null ? "Errors" : var.kinesis_stream != null ? "PutRecords.FailedRecords" : null
  total_metric  = var.lambda_function != null ? "Invocations" : var.kinesis_stream != null ? "PutRecords.TotalRecords" : null

  growth_metric      = "NumberOfMessagesSent"
  consumption_metric = "NumberOfMessagesDeleted"

  alarm_namespace   = local.use_metric_query ? var.namespace : null
  alarm_period      = local.use_metric_query ? var.period : null
  alarm_statistic   = local.use_metric_query ? var.statistic : null
  alarm_metric_name = local.use_metric_query ? local.metric_name : null
  alarm_dimensions  = local.use_metric_query ? local.dimensions : null

  defaulted_tags = merge(
    var.tags,
    {
      Name                                      = local.name
      "${var.organization}:billing:product"     = var.product
      "${var.organization}:billing:environment" = var.environment
      "${var.organization}:billing:owner"       = var.owner
      creator                                   = local.creator
      repo                                      = var.repo
    }
  )
  tags = merge({ for k, v in local.defaulted_tags : k => v if lookup(data.aws_default_tags.common_tags.tags, k, "") != v })
}

data "aws_default_tags" "common_tags" {}
