resource "aws_ecs_task_definition" "task_def" {
  family = local.task_family

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn

  container_definitions = local.container_definitions

  cpu    = var.cpu_reservation
  memory = var.memory_reservation

  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode

  track_latest = var.track_latest

  dynamic "proxy_configuration" {
    for_each = toset(local.use_envoy_sidecar ? [local.use_envoy_sidecar] : [])
    content {
      type           = "APPMESH"
      container_name = "envoy"
      properties = {
        AppPorts         = var.container_port
        EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
        IgnoredUID       = "1337"
        ProxyEgressPort  = 15001
        ProxyIngressPort = 15000
      }
    }
  }

  dynamic "volume" {
    for_each = var.efs_mounts
    content {
      name = volume.value["file_system_id"]
      efs_volume_configuration {
        file_system_id = volume.value["file_system_id"]
        root_directory = "/"
      }
    }
  }

  runtime_platform {
    operating_system_family = var.runtime_platform["operating_system_family"]
    cpu_architecture        = var.runtime_platform["cpu_architecture"]
  }

  tags = local.tags
}
