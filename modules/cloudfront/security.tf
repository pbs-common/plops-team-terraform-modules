resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = local.name
  description                       = "Origin Access Control for ${local.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
