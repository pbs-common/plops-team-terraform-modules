resource "aws_appmesh_mesh" "mesh" {
  name = local.name

  spec {
    egress_filter {
      type = local.egress_filter
    }
  }

  tags = local.tags
}
