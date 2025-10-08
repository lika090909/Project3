resource "aws_cloudfront_distribution" "alb_origin" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true

  # Only apex domain, no www
  aliases = ["lalalalalalala7.com"]

  origin {
    domain_name = module.alb_ecs.dns_name   # ✅ correct ALB DNS name
    origin_id   = "alb-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # AWS Managed CachingOptimized
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"  # AWS Managed AllViewerExceptHostHeader
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cf_cert.arn  # ✅ cert in us-east-1
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = local.common_tags
}
