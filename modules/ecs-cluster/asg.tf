resource "aws_launch_template" "launch_template" {
  count         = var.ec2_backed ? 1 : 0
  name_prefix   = local.name
  image_id      = data.aws_ami.amazon_linux_ecs.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile[0].name
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg[0].id]
  }

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo "ECS_CLUSTER=${local.name}" >> /etc/ecs/ecs.config
    EOT
  )


  tags = {
    Name        = "${local.name} launch template"
    application = var.product
    environment = var.environment
    creator     = local.creator
    repo        = var.repo
  }
}

resource "aws_autoscaling_group" "asg" {
  count                 = var.ec2_backed ? 1 : 0
  name                  = local.name
  max_size              = var.max_size
  min_size              = var.min_size
  vpc_zone_identifier   = local.vpc_zone_identifier
  max_instance_lifetime = var.max_instance_lifetime

  launch_template {
    id      = aws_launch_template.launch_template[0].id
    version = var.launch_template_version
  }

  instance_refresh {
    strategy = "Rolling"
  }

  protect_from_scale_in = var.protect_from_scale_in

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  count = var.ec2_backed ? 1 : 0
  name  = local.name

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg[0].arn

    managed_scaling {
      maximum_scaling_step_size = var.maximum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }

  tags = merge(
    local.tags,
    {
      Name = "${local.name} capacity provider"
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  count        = var.ec2_backed ? 1 : 0
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider[0].name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider[0].name
  }
}
