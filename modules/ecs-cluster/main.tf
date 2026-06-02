resource "aws_ecs_cluster" "cluster" {
  name = local.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }


  tags = local.tags
}
