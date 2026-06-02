resource "aws_route53_record" "dns" {
  count   = var.create_cname ? length(local.cnames) : 0
  zone_id = local.primary_hosted_zone_id
  name    = local.cnames[count.index]
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = var.dns_evaluate_target_health
  }
}
