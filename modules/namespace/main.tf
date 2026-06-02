resource "aws_service_discovery_http_namespace" "namespace" {
  count       = local.create_http_namespace ? 1 : 0
  name        = local.name
  description = local.description
  tags        = local.tags
}

resource "aws_service_discovery_private_dns_namespace" "namespace" {
  count       = local.create_private_namespace ? 1 : 0
  name        = local.name
  description = local.description
  vpc         = local.vpc_id
  tags        = local.tags
}

resource "aws_service_discovery_public_dns_namespace" "namespace" {
  count       = local.create_public_namespace ? 1 : 0
  name        = local.name
  description = local.description
  tags        = local.tags
}
