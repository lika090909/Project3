
module "ecs_app3" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.3.0"

  depends_on   = [module.alb_ecs]
  cluster_name = "app3"


  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }
  
  services = {
    app3-service = {
      cpu           = 512
      memory        = 1024
      desired_count = 1

     
    # Let module create roles and attach your existing secret-read policy
    create_task_iam_role       = true
    create_task_exec_iam_role  = true
    task_iam_role_policies = {
      read_secret = aws_iam_policy.app3_secrets_read.arn
    }
    task_exec_iam_role_policies = {
      exec = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    }

    # IMPORTANT: delete these lines if present (module will set ARNs itself)
    # task_role_arn      = aws_iam_role.app3_task_role.arn
    # execution_role_arn = aws_iam_role.app3_exec_role.arn

      # match app1 style
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
          { name = "REV",        value = var.release }  # <-- forces new Task Definition revision
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

      # 👇 singular map — key must match the container name above ("app3")
      load_balancer = {
        app3 = {
          target_group_arn = module.alb_ecs.target_groups["tg-3"].arn
          container_name   = "app3"
          container_port   = 8080
        }
      }

      health_check_grace_period_seconds = 60
    }
  }
}


variable "release" {
  type    = string
  default = "8"   # bump to "2","3"… to force a new TD revision
}