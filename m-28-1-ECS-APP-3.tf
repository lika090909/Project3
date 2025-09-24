
module "ecs_app3" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.3.0"
  depends_on = [module.alb_ecs]

  cluster_name = "app3"
  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

  services = {
    app3-service = {
      cpu           = 1024
      memory        = 2048
      desired_count = 2

      create_tasks_iam_role      = false
      tasks_iam_role_arn         = aws_iam_role.app3_task_role.arn
      create_tasks_exec_iam_role = false
      tasks_exec_iam_role_arn    = aws_iam_role.app3_exec_role.arn

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
      deployment_circuit_breaker = { enable = true, rollback = true }
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
        app3 = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "lika090909/app3:v1.0.1"
          readonlyRootFilesystem = false

          portMappings = [{
            name          = "app3"      # <-- fix: match container name
            containerPort = 8080        # <-- 8080 everywhere
            hostPort      = 8080
            protocol      = "tcp"
          }]

          environment = [
            { name = "SECRET_ID",  value = data.aws_secretsmanager_secret.db.arn },
            { name = "AWS_REGION", value = "us-east-1" },
            { name = "REV",        value = var.release },

            # HTTPS behind ALB
            { name = "SERVER_USE_FORWARD_HEADERS",     value = "true" },
            { name = "SERVER_TOMCAT_PROTOCOL_HEADER",  value = "x-forwarded-proto" },
            { name = "SERVER_TOMCAT_REMOTE_IP_HEADER", value = "x-forwarded-for" },

            # listen on 8080
            { name = "SERVER_ADDRESS", value = "0.0.0.0" },
            { name = "SERVER_PORT",    value = "8080" }
          ]

          # app responds on /login on 8080
          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:8080/login || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 60
          }

          cloudwatch_log_group_retention_in_days = 30
        }
      }

      load_balancer = {
        app3 = {
          target_group_arn = module.alb_ecs.target_groups["tg-3"].arn
          container_name   = "app3"
          container_port   = 8080       # <-- 8080 here too
        }
      }
    }
  }
}


