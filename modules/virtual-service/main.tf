resource "aws_appmesh_virtual_service" "virtual_service" {
  name      = local.name
  mesh_name = var.mesh_name

  spec {
    provider {
      dynamic "virtual_router" {
        for_each = local.virtual_router_name_set
        content {
          virtual_router_name = virtual_router.value
        }
      }
      dynamic "virtual_node" {
        for_each = local.virtual_node_name_set
        content {
          virtual_node_name = virtual_node.value
        }
      }
    }
  }

  tags = local.tags
}
