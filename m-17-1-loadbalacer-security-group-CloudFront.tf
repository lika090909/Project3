locals {
  # ✅ CloudFront IPv4 prefix list for origin-facing traffic
  cloudfront_ipv4_prefix_list_id = "pl-3b927c52" # ← verified in your account
}

# 👇 New SG dedicated to CloudFront ingress
resource "aws_security_group" "alb_cf_ingress" {
  name        = "alb-cf-ingress"
  description = "CloudFront ingress SG"
  vpc_id      = module.vpc.vpc_id

  # lifecycle {
  #   create_before_destroy = true
  # }

  tags = local.common_tags
}

# =========================
# IPv4 ingress from CloudFront
# =========================

resource "aws_security_group_rule" "alb_cf_http_ipv4" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [local.cloudfront_ipv4_prefix_list_id]
  security_group_id = aws_security_group.alb_cf_ingress.id
  description       = "Allow HTTP from CloudFront IPv4"
}

resource "aws_security_group_rule" "alb_cf_https_ipv4" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [local.cloudfront_ipv4_prefix_list_id]
  security_group_id = aws_security_group.alb_cf_ingress.id
  description       = "Allow HTTPS from CloudFront IPv4"
}

resource "aws_security_group_rule" "alb_cf_8080_ipv4" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  prefix_list_ids   = [local.cloudfront_ipv4_prefix_list_id]
  security_group_id = aws_security_group.alb_cf_ingress.id
  description       = "Allow 8080 from CloudFront IPv4"
}

# =========================
# Egress
# =========================
resource "aws_security_group_rule" "alb_cf_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_cf_ingress.id
  description       = "Allow all outbound"
}
