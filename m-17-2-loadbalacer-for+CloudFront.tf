module "alb_ecs" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name     = "${var.environment}-ALB-ECS"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.public_subnets   # 👈 ALB must be public

  internal = false  # 👈 ensures ALB is internet-facing

  security_groups            = [aws_security_group.alb_cf_sg.id]
  enable_deletion_protection = false
  create_security_group      = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = data.aws_acm_certificate.alb_cert.arn

      # 👇 the default forward action for root requests
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
            path_pattern = { values = ["/app1/*"] }
          }]
        }

        app2-path-rule = {
          priority = 25
          actions = [{
            type             = "forward"
            target_group_key = "tg-2"
          }]
          conditions = [{
            path_pattern = { values = ["/app2/*"] }
          }]
        }

        app3-path-rule = {
          priority = 27
          actions = [{
            type             = "forward"
            target_group_key = "tg-3"
          }]
          conditions = [{
            path_pattern = { values = ["/app3/*"] }
          }]
        }
      }
    }
  }

  target_groups = {
    tg-1 = {
      name_prefix        = "app1-"
      protocol           = "HTTP"
      port               = 80
      target_type        = "ip"
      create_attachment  = false
      health_check = {
        enabled   = true
        interval  = 30
        path      = "/app1/"
        matcher   = "200-399"
      }
    }

    tg-2 = {
      name_prefix        = "app2-"
      protocol           = "HTTP"
      port               = 80
      target_type        = "ip"
      create_attachment  = false
      health_check = {
        enabled   = true
        interval  = 30
        path      = "/app2/"
        matcher   = "200-399"
      }
    }

    tg-3 = {
      name_prefix        = "app3-"
      protocol           = "HTTP"
      port               = 8080
      target_type        = "ip"
      create_attachment  = false
      stickiness = {
        enabled = false
        type    = "lb_cookie"
      }
      health_check = {
        enabled   = true
        interval  = 30
        timeout   = 20
        path      = "/login"
        matcher   = "200-499"
      }
    }
  }

  tags = local.common_tags
}
