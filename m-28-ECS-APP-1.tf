module "ecs_app1" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.3.0"
  depends_on = [module.alb_ecs]

  cluster_name = "app1"

  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

  services = {
    app1-service = {
      cpu    = 1024         # was 512
      memory = 2048         # was 1024
      desired_count = 2
      deployment_minimum_healthy_percent = 100
      deployment_maximum_percent         = 200
      force_new_deployment               = true

      subnet_ids           = module.vpc.private_subnets
      security_group_ids   = [aws_security_group.ecs_task_sg.id]
      assign_public_ip     = false
      create_security_group = false

      runtime_platform = {
        cpu_architecture        = "X86_64"
        operating_system_family = "LINUX"
      }

      container_definitions = {
        app1 = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "lika090909/app1:v1.0.8"
          readonlyRootFilesystem = false
          portMappings = [{
            name          = "app1"
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }]
          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:80/app1/ || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 30
          }
          cloudwatch_log_group_retention_in_days = 30
        }
      }

      # 👇 NOTE: list of objects (square brackets)
        load_balancer = {
        app1 = {
          target_group_arn = module.alb_ecs.target_groups["tg-1"].arn
          container_name   = "app1"  # must match the container_definitions key
          container_port   = 80
        }
      }

      health_check_grace_period_seconds = 60
    }
  }
}
