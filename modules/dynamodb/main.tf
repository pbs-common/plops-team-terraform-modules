resource "aws_dynamodb_table" "table" {
  name           = local.name
  billing_mode   = var.billing_mode
  read_capacity  = local.min_capacity
  write_capacity = local.min_capacity
  hash_key       = var.hash_key.name
  range_key      = local.range_key

  attribute {
    name = var.hash_key.name
    type = var.hash_key.type
  }

  dynamic "attribute" {
    for_each = local.range_key_attributes
    content {
      name = var.range_key.name
      type = var.range_key.type
    }
  }

  dynamic "attribute" {
    for_each = local.additional_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "ttl" {
    for_each = local.ttl
    content {
      attribute_name = ttl.key
      enabled        = ttl.value.enabled
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indices
    content {
      name               = global_secondary_index.key
      hash_key           = global_secondary_index.value.hash_key
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indices
    content {
      name               = local_secondary_index.key
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }


  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
}


resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count              = local.pay_per_request ? 0 : 1
  max_capacity       = local.max_capacity
  min_capacity       = local.min_capacity
  resource_id        = "table/${local.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [
    aws_dynamodb_table.table,
  ]
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count              = local.pay_per_request ? 0 : 1
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.target_value
  }

  depends_on = [
    aws_appautoscaling_target.dynamodb_table_read_target,
  ]
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count              = local.pay_per_request ? 0 : 1
  max_capacity       = local.max_capacity
  min_capacity       = local.min_capacity
  resource_id        = "table/${local.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  depends_on = [
    aws_dynamodb_table.table,
  ]
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count              = local.pay_per_request ? 0 : 1
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.target_value
  }

  depends_on = [
    aws_appautoscaling_target.dynamodb_table_write_target,
  ]
}
