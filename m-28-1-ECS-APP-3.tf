module "ecs_app3" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">= 6.3.0"

  depends_on   = [module.vpc]
  cluster_name = "app3"

  default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

  services = {
    app3-service = {
      cpu                  = 512
      memory               = 1024
      desired_count        = 1
      subnet_ids           = module.vpc.private_subnets
      security_group_ids   = [aws_security_group.ecs_task_sg.id]
      assign_public_ip     = false
      create_security_group = false

    # NEW ADJUSTMENT FOR APP3 
     create_task_role       = false
     create_task_exec_role  = false
     task_role_arn          = aws_iam_role.app3_task_role.arn
     task_exec_role_arn     = aws_iam_role.app3_exec_role.arn
     force_new_deployment   = true


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
          
         
          # environment = [
          #  { name = "DB_ENDPOINT", value = local.db.host },
          #  { name = "DB_NAME",     value = local.db.dbname },
          #  { name = "DB_USERNAME", value = local.db.username },
          #  { name = "DB_PASSWORD", value = local.db.password },
          #  { name = "DB_PORT",     value = tostring(local.db.port) }, # optional; defaults to 3306 in script
          #  ]
          
          environment = [
            { name = "SECRET_ID",  value = data.aws_secretsmanager_secret.db.name },  # or use the ARN if you prefer
            { name = "AWS_REGION", value = "us-east-1" }                              # your region
          ]

          healthCheck = {
            command     = ["CMD-SHELL", "curl -sf http://localhost:8080/login || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 30
          }
        
          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "/ecs/app3/app3-service"
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "app3"
            }
          }
        

          cloudwatch_log_group_retention_in_days = 30
        }
      }

      load_balancers = [{
        target_group_arn = module.alb_ecs.target_groups["tg-3"].arn
        container_name   = "app3"
        container_port   = 8080
      }]
    }
  }
}
