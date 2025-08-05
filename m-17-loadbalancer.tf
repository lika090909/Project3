module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"
  
  name    = "${var.environment}-ALB"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  
  enable_deletion_protection = false
  security_groups = [module.alb_SG.security_group_id]

  
  listeners = {
    http= {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "tg-1"
      }
    }
  }

   target_groups = {
    tg-1 = {
      #   name_prefix                   = "h1"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      
      
     
    tags = local.common_tags
   
}
   }
}

# targets = [
#        {
#         target_id = module.ec2-instance_private_az1.id
#         port      = 80
#       },
#       {
#         target_id = module.ec2-instance_private_az2.id
#         port      = 80
#       }
#     ]

resource "aws_lb_target_group_attachment" "tg1" {
  for_each = {for k, v in module.ec2_private: k => v}
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}

