
# Web ACL (global scope for CloudFront)
resource "aws_wafv2_web_acl" "cf_waf" {
  provider = aws.us_east_1
  name     = "cf-waf"
  scope    = "CLOUDFRONT"    # <- required for CloudFront

  default_action { allow {} }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cfWAF"
    sampled_requests_enabled   = true
  }

  # Managed rule sets (good baseline)
  rule {
    name     = "AWSCommon"
    priority = 1
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action { none {} }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSCommon"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "KnownBadInputs"
    priority = 2
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    override_action { none {} }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "IPReputation"
    priority = 3
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    override_action { none {} }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IPReputation"
      sampled_requests_enabled   = true
    }
  }

  # Optional: basic rate limiting (tune the limit)
  rule {
    name     = "RateLimitAll"
    priority = 10
    statement {
      rate_based_statement {
        limit              = 2000         # requests per 5-minute window per IP
        aggregate_key_type = "IP"
      }
    }
    action { block {} }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitAll"
      sampled_requests_enabled   = true
    }
  }
}
