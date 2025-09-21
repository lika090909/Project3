module "ecs_app3" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.4.0" # registry shows this as the newest available to you

  depends_on   = [module.alb_ecs]
  cluster_name = "app3"

  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

  services = {
    app3-service = {
      cpu           = 512
      memory        = 1024
      desired_count = 1

      # ✅ Let the module CREATE the task role and ATTACH your managed policy (Terraform-only)
      create_task_iam_role      = true
      task_iam_role_policy_arns = [aws_iam_policy.app3_secrets_read.arn]

      # ✅ Execution role (logs/image pulls)
      create_task_exec_iam_role = false
      execution_role_arn        = aws_iam_role.app3_exec_role.arn
      task_exec_iam_role_arn    = aws_iam_role.app3_exec_role.arn

      deployment_minimum_healthy_percent = 100
      deployment_maximum_percent         = 200
      force_new_deployment               = true

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
            name          = "app3"
            containerPort = 8080
            hostPort      = 8080
            protocol      = "tcp"
          }]

          environment = [
            { name = "SECRET_ID",  value = data.aws_secretsmanager_secret.db.name },
            { name = "AWS_REGION", value = "us-east-1" },
            { name = "REV",        value = var.release } # bump to force new TD revision
          ]

          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:8080/login || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 30
          }

          cloudwatch_log_group_retention_in_days = 30
        }
      }

      load_balancer = {
        app3 = {
          target_group_arn = module.alb_ecs.target_groups["tg-3"].arn
          container_name   = "app3"
          container_port   = 8080
        }
      }

      health_check_grace_period_seconds = 120
    }
  }
}

variable "release" {
  type    = string
  default = "13" # <- bump when you want a new task definition
}
