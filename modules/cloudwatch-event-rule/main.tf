resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = local.name
  description = local.description

  event_pattern = var.event_pattern

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "event_target" {
  for_each  = var.targets
  target_id = each.key
  rule      = aws_cloudwatch_event_rule.event_rule.name
  arn       = each.value.arn
  role_arn  = lookup(each.value, "role_arn", null)
}

resource "aws_lambda_permission" "allow_event_invocation" {
  for_each            = var.lambda_permissions
  statement_id_prefix = each.key
  action              = "lambda:InvokeFunction"
  function_name       = each.value
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.event_rule.arn
}
