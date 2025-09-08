module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">= 6.3.0"

  depends_on   = [module.vpc]
  cluster_name = "app1"
  

  default_capacity_provider_strategy = {
    FARGATE = { weight = 100, base = 1 }
  }

  services = {
    ecsdemo-frontend = {
      cpu           = 512
      memory        = 1024
      desired_count = 1

      # ✅ Use these (module expects them):
      subnet_ids         = module.vpc.public_subnets
      security_group_ids = [module.security-group_bastion.security_group_id]
      assign_public_ip   = true   # keep false if you have a NAT; true only in public subnets
      create_security_group = false
      container_definitions = {
        app1 = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "lika090909/app1-amd64:latest"

          portMappings = [
            {
              name          = "app1"
              containerPort = 80
              hostPort      = 80
              protocol      = "tcp"
            }
          ]

          # healthCheck = {
          #   command     = ["CMD-SHELL", "curl -sf http://localhost:80/app1 || exit 1"]
          #   interval    = 30
          #   timeout     = 5
          #   retries     = 3
          #   startPeriod = 10
          # }

          cloudwatch_log_group_retention_in_days = 30
        }
      }
    }
  }

 
  

  tags = local.common_tags
}
