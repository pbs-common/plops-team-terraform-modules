locals {
  ssm_path_envs = [
    {
      "name" : "SSM_PATH",
      "value" : local.ssm_path
    }
  ]
  env_vars = local.ssm_path == null ? var.env_vars : var.env_vars == null ? local.ssm_path_envs : setunion(
    local.ssm_path_envs,
    var.env_vars
  )


  app_log_configuration = merge(
    local.use_newrelic_firelens_sidecar ? {
      "logDriver" : "awsfirelens",
      "options" : {
        "Name" : "newrelic"
      },
      "secretOptions" : [{
        "name" : "apiKey",
        "valueFrom" : local.newrelic_secret_arn
      }]
    } : null,
    local.use_newrelic_firelens_sidecar ? null : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : local.log_group_name,
        "awslogs-region" : data.aws_region.current.id,
        "awslogs-stream-prefix" : local.container_name
        "mode" : var.awslogs_driver_mode
      }
    }
  )

  use_envoy_sidecar = var.mesh_name != null && var.virtual_node != null

  specify_command    = var.command != null
  specify_entrypoint = var.entrypoint != null

  app_container_definition = merge(
    {
      "name" : local.container_name,
      "image" : "${var.image_repo}:${var.image_tag}",
      "environment" : local.env_vars,
      "portMappings" : [{
        "containerPort" : var.container_port
      }],
      "essential" : true,
      "logConfiguration" : local.app_log_configuration,
    },
    length(var.secrets) == 0 ? {} :
    {
      "secrets" : [
        for secret in var.secrets : {
          name      = secret.name
          valueFrom = secret.valueFrom
        }
      ]
    },
    length(var.efs_mounts) == 0 ? {} : {
      "mountPoints" : [
        for mount in var.efs_mounts : {
          sourceVolume  = mount.file_system_id
          containerPath = mount.container_path
        }
      ]
    },
    !local.use_envoy_sidecar ? {} : {
      "dependsOn" : [
        {
          "containerName" : "envoy",
          "condition" : "HEALTHY"
        }
      ]
    },
    !local.specify_command ? {} : {
      "command" : var.command,
    },
    !local.specify_entrypoint ? {} : {
      "entrypoint" : var.entrypoint,
    }
  )

  xray_container_definition = {
    "name" : "xray-daemon",
    "image" : "amazon/aws-xray-daemon",
    "user" : "1337",
    "essential" : true,
    "cpu" : 32,
    "memoryReservation" : 256,
    "portMappings" : [
      {
        "containerPort" : 2000,
        "protocol" : "udp"
      }
    ],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : local.log_group_name,
        "awslogs-region" : data.aws_region.current.id,
        "awslogs-stream-prefix" : "xray"
      }
    }
  }

  newrelic_firelens_container_definition = {
    "name" : "firelens",
    "essential" : true,
    "image" : var.newrelic_firelens_image,
    "firelensConfiguration" : {
      "type" : "fluentbit",
      "options" : {
        "enable-ecs-log-metadata" : "true"
      }
    }
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : local.log_group_name,
        "awslogs-region" : data.aws_region.current.id,
        "awslogs-stream-prefix" : "firelens"
      }
    }
  }



  null_safe_mesh_name       = var.mesh_name != null ? var.mesh_name : ""
  null_safe_virtual_gateway = var.virtual_gateway != null ? var.virtual_gateway : ""
  null_safe_virtual_node    = var.virtual_node != null ? var.virtual_node : ""

  envoy_standalone_container_definition = {
    "name" : local.container_name,
    "image" : "public.ecr.aws/appmesh/aws-appmesh-envoy:${var.envoy_tag}",
    "essential" : true,
    "environment" : [
      {
        "name" : "APPMESH_RESOURCE_ARN",
        "value" : "arn:aws:appmesh:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:mesh/${local.null_safe_mesh_name}/virtualGateway/${local.null_safe_virtual_gateway}"
      },
      {
        "name" : "ENABLE_ENVOY_XRAY_TRACING",
        "value" : "1"
      }
    ],
    "healthCheck" : {
      "command" : [
        "CMD-SHELL",
        "curl -s http://localhost:9901/server_info | grep state | grep -q LIVE"
      ],
      "interval" : 5,
      "retries" : 3,
      "startPeriod" : 10,
      "timeout" : 2
    },
    "user" : "1337",
    "portMappings" : [
      {
        "containerPort" : var.container_port,
        "protocol" : "tcp"
      }
    ],
    "logConfiguration" : local.app_log_configuration
  }

  envoy_proxy_container_definition = {
    "name" : "envoy",
    "image" : "public.ecr.aws/appmesh/aws-appmesh-envoy:${var.envoy_tag}",
    "essential" : true,
    "environment" : [
      {
        "name" : "APPMESH_RESOURCE_ARN",
        "value" : "arn:aws:appmesh:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:mesh/${local.null_safe_mesh_name}/virtualNode/${local.null_safe_virtual_node}"
      },
      {
        "name" : "ENABLE_ENVOY_XRAY_TRACING",
        "value" : "1"
      }
    ],
    "healthCheck" : {
      "command" : [
        "CMD-SHELL",
        "curl -s http://localhost:9901/server_info | grep state | grep -q LIVE"
      ],
      "interval" : 5,
      "retries" : 3,
      "startPeriod" : 10,
      "timeout" : 2
    },
    "memory" : 500,
    "user" : "1337",
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : local.log_group_name,
        "awslogs-region" : data.aws_region.current.id,
        "awslogs-stream-prefix" : "proxy"
      }
    }
  }

  cwagent_container_definition = {
    "name" : "ecs-cwagent",
    "image" : "public.ecr.aws/cloudwatch-agent/cloudwatch-agent:latest",
    "essential" : true,
    "secrets" : [
      {
        "name" : "CW_CONFIG_CONTENT",
        "valueFrom" : "ecs-cwagent"
      }
    ],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-create-group" : "true",
        "awslogs-group" : "/ecs/ecs-cwagent",
        "awslogs-region" : data.aws_region.current.id,
        "awslogs-stream-prefix" : "ecs"
      }
    }
  }


  use_virtual_gateway_def = var.mesh_name != null && var.virtual_gateway != null
  use_virtual_node_def    = var.mesh_name != null && var.virtual_node != null

  use_app_container              = !local.use_virtual_gateway_def
  use_envoy_standalone_container = local.use_virtual_gateway_def
  use_xray_sidecar               = var.use_xray_sidecar != null ? var.use_xray_sidecar : local.use_virtual_node_def || local.use_virtual_gateway_def
  use_newrelic_firelens_sidecar  = var.newrelic_secret_arn != null || var.newrelic_secret_name != null

  container_definitions = var.container_definitions != null ? var.container_definitions : jsonencode(
    concat(
      local.use_envoy_standalone_container ? [local.envoy_standalone_container_definition] : [],
      local.use_app_container ? [local.app_container_definition] : [],
      local.use_newrelic_firelens_sidecar ? [local.newrelic_firelens_container_definition] : [],
      local.use_envoy_sidecar ? [local.envoy_proxy_container_definition] : [],
      local.use_xray_sidecar ? [local.xray_container_definition] : [],
      var.use_cwagent_sidecar ? [local.cwagent_container_definition] : [],
    )
  )
}
