module "alb_ecs" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name            = "${var.environment}-ALB-ECS"
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
    
    # Here we are just opening the port 8080, if we want to connect like ALB_DNS:8080 
    
    java-https-redirect = {
      port     = 8080
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
        target_group_key = "tg-3"
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

        app3-path-rule = {
          priority = 27
          actions = [{
            type             = "forward"
            target_group_key = "tg-3"
          }]
          conditions = [{
            path_pattern = {
              values = ["/"]
            }
          }]
        }

        # ex-fixed-response = {
        #   priority = 30
        #   actions = [{
        #     type         = "fixed-response"
        #     content_type = "text/plain"
        #     status_code  = 200
        #     message_body = "This is a fixed response"
        #   }]
        #   conditions = [{
        #     path_pattern = {
        #       values = ["/"]
        #     }
        #   }]
        # }


      }
    }
  }

   # Target group TYPE attachment and a Health check
   
  target_groups = {
    tg-1 = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      create_attachment                 = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }

   # Target group TYPE attachment and a Health check
    tg-2 = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      create_attachment                 = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }

    tg-3 = {
      protocol                          = "HTTP"
      port                              = 8080
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      create_attachment                 = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = 8080
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

# resource "aws_lb_target_group_attachment" "tg_1" {
#   target_group_arn = module.alb.target_groups["tg-1"].arn
#   for_each         = { for k, v in module.ec2-instance_private-app1 : k => v }
#   target_id        = each.value.id  # your EC2 instance ID
#   port             = 80             # must match target group port
# }


# resource "aws_lb_target_group_attachment" "tg_2" {
#   target_group_arn = module.alb.target_groups["tg-2"].arn
#   for_each         = { for k, v in module.ec2-instance_private-app2 : k => v }
#   target_id        = each.value.id  # your EC2 instance ID
#   port             = 80             # must match target group port
# }
