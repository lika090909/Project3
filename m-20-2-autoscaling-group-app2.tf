# module "autoscaling_app2" {
#   source  = "terraform-aws-modules/autoscaling/aws"
#   version = "9.0.1"

#   name            = "${var.environment}-ASG-${each.value}"
#   use_name_prefix = true

#   instance_name   = "${var.environment}-EC2-APP2-${each.value}"

#   for_each = toset(module.vpc.azs)
#   vpc_zone_identifier = [
#     module.vpc.private_subnets[index(module.vpc.azs, each.value)]
#   ]

#   ignore_desired_capacity_changes = true

#   min_size                  = 1
#   max_size                  = 2
#   desired_capacity          = 1
#   wait_for_capacity_timeout = 0
#   default_instance_warmup   = 300
#   health_check_type         = "EC2"
#  #   vpc_zone_identifier       = module.vpc.private_subnets
  
#    traffic_source_attachments = {
#     alb = {
#       traffic_source_identifier = module.alb.target_groups["tg-2"].arn
#       traffic_source_type       = "elbv2" # default
#     }
#   }

#   initial_lifecycle_hooks = [
#     {
#       name                 = "ExampleStartupLifeCycleHook"
#       default_result       = "CONTINUE"
#       heartbeat_timeout    = 60
#       lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      
#     },
#     {
#       name                 = "ExampleTerminationLifeCycleHook"
#       default_result       = "CONTINUE"
#       heartbeat_timeout    = 60
#       lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      
#     }
#   ]

#   #How many instances you want to keep EC2s healthy at any time 

#   instance_maintenance_policy = {
#     min_healthy_percentage = 100
#     max_healthy_percentage = 110
#   }

#   instance_refresh = {
#     strategy = "Rolling"
#     preferences = {
#       checkpoint_delay             = 600
#       checkpoint_percentages       = [35, 70, 100]
#       instance_warmup              = 300
#       min_healthy_percentage       = 50
#       max_healthy_percentage       = 100
#       auto_rollback                = true
#       scale_in_protected_instances = "Refresh"
#       standby_instances            = "Terminate"
#       skip_matching                = false
#     #   alarm_specification = {
#     #     alarms = [module.auto_rollback.cloudwatch_metric_alarm_id]
#     #   }
#     }
    
#     triggers = ["launch_template"] 
#   }

#    # Launch template
#   launch_template_id       = aws_launch_template.myec2_launch_template-app2.id
#   create_launch_template = false
#   launch_template_version = tostring(aws_launch_template.myec2_launch_template-app2.latest_version)  

#   tags = local.common_tags

# }

