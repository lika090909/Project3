# module "ecs_app3" {
#   source  = "terraform-aws-modules/ecs/aws"
#   version = ">= 6.3.0"

#   depends_on   = [module.vpc]
#   cluster_name = "app3"

#   default_capacity_provider_strategy = { FARGATE = { weight = 100, base = 1 } }

#   services = {
#     app3-service = {
#       cpu                  = 512
#       memory               = 1024
#       desired_count        = 1
#       subnet_ids           = module.vpc.private_subnets
#       security_group_ids   = [aws_security_group.ecs_task_sg.id]
#       assign_public_ip     = false
#       create_security_group = false

#       runtime_platform = {
#         cpu_architecture        = "X86_64"
#         operating_system_family = "LINUX"
#       }

#       container_definitions = {
#         app3 = {
#           cpu       = 512
#           memory    = 1024
#           essential = true
#           image     = "lika090909/app3:v1.0.1"
#           readonlyRootFilesystem = false

#           portMappings = [{
#             name          = "app3"
#             containerPort = 8080
#             hostPort      = 8080
#             protocol      = "tcp"
#           }]

#           healthCheck = {
#             command     = ["CMD-SHELL", "curl -sf http://localhost:8080/login || exit 1"]
#             interval    = 30
#             timeout     = 5
#             retries     = 3
#             startPeriod = 30
#           }

#           cloudwatch_log_group_retention_in_days = 30
#         }
#       }

#       load_balancers = [{
#         target_group_arn = module.alb_ecs.target_groups["tg-3"].arn
#         container_name   = "app3"
#         container_port   = 8080
#       }]
#     }
#   }
# }
