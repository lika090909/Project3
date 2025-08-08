

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"
  name    = "${var.environment}-ALB"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.alb_SG.security_group_id]

  enable_deletion_protection = false
  create_security_group = false

#   security_group_ingress_rules = {
#     all_http = {
#       from_port   = 80
#       to_port     = 82
#       ip_protocol = "tcp"
#       description = "HTTP web traffic"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }

#   security_group_egress_rules = {
#     all = {
#       ip_protocol = "-1"
#       cidr_ipv4   = module.vpc.vpc_cidr_block
#     }
#   }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "tg-1"
      }
    }
  }

  target_groups = {
    tg-1 = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      create_attachment                 = false # <--- REQUIRED FOR EXTERNAL ATTACHMENTS

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  tags = local.common_tags
}


resource "aws_lb_target_group_attachment" "tg_1" {
  target_group_arn = module.alb.target_groups["tg-1"].arn
  for_each = {for k, v in module.ec2-instance_private: k => v}
  target_id        = each.value.id
  port             = 80
}
