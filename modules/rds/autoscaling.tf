locals {
  autoscaling_predefined_metric = {
    cpu         = "RDSReaderAverageCPUUtilization"
    connections = "RDSReaderAverageDatabaseConnectionsUtilization"
  }
}

resource "aws_appautoscaling_target" "replicas" {
  count              = var.autoscaling_enabled ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.db.id}"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "replicas" {
  count              = var.autoscaling_enabled ? 1 : 0
  name               = "${var.autoscaling_metric_type}-auto-scaling"
  service_namespace  = aws_appautoscaling_target.replicas[0].service_namespace
  scalable_dimension = aws_appautoscaling_target.replicas[0].scalable_dimension
  resource_id        = aws_appautoscaling_target.replicas[0].resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = local.autoscaling_predefined_metric[var.autoscaling_metric_type]
    }

    target_value       = var.autoscaling_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
