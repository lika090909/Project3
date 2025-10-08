resource "aws_security_group" "alb_cf_sg" {
  name        = "${var.environment}-alb-cf-sg"   # ✅ fixed name
  description = "ALB accessible only from CloudFront"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = ["pl-3b927c52"]
    description     = "HTTP from CloudFront"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-3b927c52"]
    description     = "HTTPS from CloudFront"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
