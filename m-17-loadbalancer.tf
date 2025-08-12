module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name            = "${var.environment}-ALB"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_SG.security_group_id]
  enable_deletion_protection = false
  create_security_group      = false

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    listener-https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = data.aws_acm_certificate.issued.arn

      # Default forward if no rule matches
      forward = {
        target_group_key = "tg-1"
      }

      rules = {
        app1-path-rule = {
          priority = 10
          actions = [{
            type             = "forward"
            target_group_key = "tg-1"
          }]
          conditions = [{
            path_pattern = {
              values = ["/app1*"]
            }
          }]
        }


        app2-path-rule = {
          priority = 25
          actions = [{
            type             = "forward"
            target_group_key = "tg-2"
          }]
          conditions = [{
            path_pattern = {
              values = ["/app2*"]
            }
          }]
        }

        ex-fixed-response = {
          priority = 30
          actions = [{
            type         = "fixed-response"
            content_type = "text/plain"
            status_code  = 200
            message_body = "This is a fixed response"
          }]
          conditions = [{
            path_pattern = {
              values = ["/"]
            }
          }]
        }
        welcome-path-app1 = {
           priority = 40
           actions = [{
            type  = "forward"
            target_group_key = "tg-1"  
           }]
          conditions = [{
            path_pattern = {
              values = ["/welcome*"]
            }
           }]
        }

        welcome-path-app2 = {
           priority = 50
           actions = [{
            type  = "forward"
            target_group_key = "tg-2"  
           }]
          conditions = [{
            path_pattern = {
              values = ["/welcome*"]
            }
           }]
        }

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
      create_attachment                 = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/invite.html"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }


    tg-2 = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      create_attachment                 = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/movie-ranking.html"
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
  for_each         = { for k, v in module.ec2-instance_private-app1 : k => v }
  target_id        = each.value.id  # your EC2 instance ID
  port             = 80             # must match target group port
}


resource "aws_lb_target_group_attachment" "tg_2" {
  target_group_arn = module.alb.target_groups["tg-2"].arn
  for_each         = { for k, v in module.ec2-instance_private-app2 : k => v }
  target_id        = each.value.id  # your EC2 instance ID
  port             = 80             # must match target group port
}
