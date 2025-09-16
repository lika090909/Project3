module "ecs_app2" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.3.0"

  depends_on = [module.vpc, module.alb_ecs]
  cluster_name = "app2"
  

  default_capacity_provider_strategy = {
    FARGATE = { weight = 100, base = 1 }
  }

  services = {
    app2-service = {
      cpu           = 512
      memory        = 1024
      desired_count = 1

      # ✅ Use these (module expects them):
      subnet_ids         = module.vpc.private_subnets
      security_group_ids = [aws_security_group.ecs_task_sg.id]
      assign_public_ip   = false   # keep false if you have a NAT; true only in public subnets
      create_security_group = false

      runtime_platform = {
      cpu_architecture        = "X86_64"
      operating_system_family = "LINUX"
      }

      container_definitions = {
        app2 = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "lika090909/app2:v1.0.1"
          
          readonlyRootFilesystem = false
           
          portMappings = [
            {
              name          = "app2"
              containerPort = 80
              hostPort      = 80
              protocol      = "tcp"
            }
          ]

          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:80/app2/ || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 30
          }

          cloudwatch_log_group_retention_in_days = 30
        }
      }

     # ⬇️ FIXED: map, and correct module name
    # load_balancers = {

    #   app2 = {
    #     target_group_arn = module.alb_ecs.target_groups["tg-2"].arn
    #     container_name   = "app2"
    #     container_port   = 80
    #   }
    # }

    load_balancers = {
      app2 = {
        target_group_arn = module.alb_ecs.target_groups["tg-2"].arn
        container_name   = "app2"
        container_port   = 80
      }
    }
    }
  }

 
  

  tags = local.common_tags
}
