resource "aws_appmesh_virtual_gateway" "gateway" {
  name      = local.name
  mesh_name = var.mesh_name

  spec {
    listener {
      port_mapping {
        port     = var.container_port
        protocol = var.listener_protocol
      }
    }
  }

  tags = local.tags
}

module "envoy_service" {
  source = "github.com/pbs/terraform-aws-ecs-service-module?ref=7.2.0"

  name = local.name

  primary_hosted_zone = var.primary_hosted_zone
  private_hosted_zone = var.private_hosted_zone

  mesh_name       = var.mesh_name
  virtual_gateway = aws_appmesh_virtual_gateway.gateway.name

  load_balancer_type = var.load_balancer_type

  container_name = var.container_name
  container_port = var.container_port

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  subnets = local.subnets
  vpc_id  = local.vpc_id

  cluster = var.cluster

  cnames  = local.cnames
  aliases = local.aliases

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
