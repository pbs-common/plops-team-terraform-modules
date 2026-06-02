resource "aws_route53_record" "primary" {
  count   = var.create_dns ? 1 : 0
  zone_id = local.private_hosted_zone
  name    = "${local.name}-db"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [local.dns_target]
}

resource "aws_route53_record" "reader" {
  count   = var.create_dns ? 1 : 0
  zone_id = local.private_hosted_zone
  name    = "${local.name}-db-ro"
  type    = "CNAME"
  ttl     = var.dns_ttl
  records = [local.reader_dns_target]
}
