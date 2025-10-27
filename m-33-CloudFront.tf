#######################################
# CloudFront Distribution
#######################################
resource "aws_cloudfront_distribution" "alb_origin" {
  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["lalalalalalala7.com"]

  origin {
    domain_name = module.alb_ecs.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # 🔐 Optional — if you want extra security between CF and ALB
    # origin_custom_header {
    #   name  = "X-Origin-Secret"
    #   value = var.cloudfront_origin_secret
    # }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]

    # ⚡ No caching, just pass through
    cache_policy_id          = aws_cloudfront_cache_policy.no_cache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.all_viewer_simple.id

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

#######################################
# Origin Request Policy
#######################################
resource "aws_cloudfront_origin_request_policy" "all_viewer_simple" {
  name = "AllViewerSimple"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host"]
    }
  }

  cookies_config {
    cookie_behavior = "all"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

#######################################
# No Cache Policy (valid)
#######################################
resource "aws_cloudfront_cache_policy" "no_cache" {
  name = "no-cache-policy"

  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "none"
    }

    # ❌ No cookies in cache policy (they’re forwarded via origin request policy)
    cookies_config {
      cookie_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

#######################################
# Redirect Function
#######################################
resource "aws_cloudfront_function" "redirect_root" {
  name    = "redirect-root-to-login"
  runtime = "cloudfront-js-1.0"
  comment = "Redirect / to /login"

  code = <<-EOF
    function handler(event) {
      var request = event.request;
      if (request.uri === '/' || request.uri === '') {
        return {
          statusCode: 301,
          statusDescription: 'Moved Permanently',
          headers: { 'location': { value: '/login' } }
        };
      }
      return request;
    }
  EOF
}
