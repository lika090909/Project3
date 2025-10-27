#######################################
# CloudFront IPv4 Prefix List
#######################################
locals {
  cloudfront_ipv4_prefix_list_id = "pl-3b927c52"
}

#######################################
# ALB SG — HTTPS
#######################################
resource "aws_security_group" "alb_https_sg" {
  name        = "alb-https-sg"
  description = "Allow HTTPS from CloudFront"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_https_ingress_cf" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [local.cloudfront_ipv4_prefix_list_id]
  security_group_id = aws_security_group.alb_https_sg.id
}

resource "aws_security_group_rule" "alb_https_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb_https_sg.id
}

#######################################
# ALB SG — 8080 (App3)
#######################################
resource "aws_security_group" "alb_8080_sg" {
  name        = "alb-8080-sg"
  description = "Allow 8080 from CloudFront"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_8080_ingress_cf" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  prefix_list_ids   = [local.cloudfront_ipv4_prefix_list_id]
  security_group_id = aws_security_group.alb_8080_sg.id
}

resource "aws_security_group_rule" "alb_8080_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb_8080_sg.id
}
