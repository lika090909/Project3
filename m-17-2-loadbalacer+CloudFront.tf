module "alb_ecs" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name        = "${var.environment}-ALB-ECS"
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.public_subnets

  security_groups = [
    aws_security_group.alb_https_sg.id,
    aws_security_group.alb_8080_sg.id
  ]

  enable_deletion_protection = false
  create_security_group      = false
  ip_address_type            = "ipv4"

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = data.aws_acm_certificate.issued.arn

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
            path_pattern = { values = ["/app1*"] }
          }]
        }

        app2-path-rule = {
          priority = 25
          actions = [{
            type             = "forward"
            target_group_key = "tg-2"
          }]
          conditions = [{
            path_pattern = { values = ["/app2*"] }
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
      protocol            = "HTTP"
      port                = 80
      target_type         = "ip"
      create_attachment   = false
      deregistration_delay = 10

      health_check = {
        enabled   = true
        interval  = 30
        path      = "/app1/"
        port      = 80
        protocol  = "HTTP"
        matcher   = "200-399"
      }
    }

    tg-2 = {
      protocol            = "HTTP"
      port                = 80
      target_type         = "ip"
      create_attachment   = false
      deregistration_delay = 10

      health_check = {
        enabled   = true
        interval  = 30
        path      = "/app2/"
        port      = 80
        protocol  = "HTTP"
        matcher   = "200-399"
      }
    }

    tg-3 = {
      protocol            = "HTTP"
      port                = 8080
      target_type         = "ip"
      create_attachment   = false
      deregistration_delay = 10

      health_check = {
        enabled   = true
        interval  = 30
        path      = "/login"
        port      = 8080
        protocol  = "HTTP"
        matcher   = "200-399"
      }
    }
  }
}
