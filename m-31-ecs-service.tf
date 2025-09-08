# module "ecs_service" {
#   source  = "terraform-aws-modules/ecs/aws"
#   version = "6.3.0"

#   name        = "app1-service"
#   cluster_arn = module.ecs.cluster_arn

#   cpu    = 1024
#   memory = 4096

#   # Enables ECS Exec
#   enable_execute_command = true

#   # for blue/green deployments
#   deployment_configuration = {
#     strategy             = "BLUE_GREEN"
#     bake_time_in_minutes = 2

# }