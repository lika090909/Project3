module "ecs_app1" {
  source     = "terraform-aws-modules/ecs/aws"
  version    = "6.3.0"
  depends_on = [module.alb_ecs]

  cluster_name                       = "app1"
  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

  services = {
    app1-service = {
      cpu           = 1024
      memory        = 2048
      desired_count = 2

      # autoscaling @ 50% CPU
      enable_autoscaling       = true
      autoscaling_min_capacity = 2
      autoscaling_max_capacity = 6
      autoscaling_policies = {
        cpu = {
          policy_type = "TargetTrackingScaling"
          target_tracking_scaling_policy_configuration = {
            target_value = 50
            predefined_metric_specification = {
              predefined_metric_type = "ECSServiceAverageCPUUtilization"
            }
            scale_in_cooldown  = 600
            scale_out_cooldown = 60
          }
        }
      }

      deployment_minimum_healthy_percent = 100
      deployment_maximum_percent         = 200
      force_new_deployment               = true
      deployment_circuit_breaker         = { enable = true, rollback = true }
      health_check_grace_period_seconds  = 180

      subnet_ids            = module.vpc.private_subnets
      security_group_ids    = [aws_security_group.ecs_task_sg.id]
      assign_public_ip      = false
      create_security_group = false

      runtime_platform = {
        cpu_architecture        = "X86_64"
        operating_system_family = "LINUX"
      }

      container_definitions = {
        app1 = {
          cpu                    = 512
          memory                 = 1024
          essential              = true
          image                  = "lika090909/app1:v1.0.8"
          readonlyRootFilesystem = false

          portMappings = [{
            name          = "app1"
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }]

          # make the app trust ALB headers and keep https scheme/443 port
          environment = [
            { name = "SERVER_USE_FORWARD_HEADERS", value = "true" },
            { name = "SERVER_TOMCAT_PROTOCOL_HEADER", value = "x-forwarded-proto" },
            { name = "SERVER_TOMCAT_REMOTE_IP_HEADER", value = "x-forwarded-for" },
            { name = "SERVER_TOMCAT_PORT_HEADER", value = "x-forwarded-port" },
            { name = "SERVER_TOMCAT_INTERNAL_PROXIES", value = ".*" }
          ]

          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:80/app1/ || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 60
          }

          cloudwatch_log_group_retention_in_days = 30
        }
      }

      load_balancer = {
        app1 = {
          target_group_arn = module.alb_ecs.target_groups["tg-1"].arn
          container_name   = "app1"
          container_port   = 80
        }
      }
    }
  }
}
