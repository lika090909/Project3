resource "aws_cloudfront_distribution" "alb_origin" {
  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["lalalalalalala7.com"]

  # 🧰 optional: attach WAF later
  # web_acl_id = aws_wafv2_web_acl.cf_waf.arn  

  origin {
    domain_name = module.alb_ecs.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # 👇 ✅ Add custom security header for ALB validation
  #   origin_custom_header {
  #     name  = "X-Origin-Secret"
  #     value = var.cloudfront_origin_secret
  #   }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]

    cache_policy_id          = aws_cloudfront_cache_policy.no_cache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.all_viewer_with_auth.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect_root.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  wait_for_deployment = true
}
