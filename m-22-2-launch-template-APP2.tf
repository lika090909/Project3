# resource "aws_launch_template" "myec2_launch_template-app2" {
  
#   name = "${var.environment}-EC2-APP2"

#   user_data           = filebase64("${path.module}/APP-2.sh")
#   instance_type = var.instance_type
#   key_name = var.private-ec2-keypair
#   vpc_security_group_ids = [module.security-group_private.security_group_id]

#   update_default_version = true 

#   block_device_mappings {
#     device_name = "/dev/sdf"

#     ebs {
#       volume_size = 10
#     }
#   }

# #   capacity_reservation_specification {
# #     capacity_reservation_preference = "open"
# #   }

#   cpu_options {
#     core_count       = 1
#     threads_per_core = 2
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   disable_api_stop        =  false
#   disable_api_termination = false

#   ebs_optimized = true

#   image_id =  data.aws_ami.amz-2023.id

#   instance_initiated_shutdown_behavior = "terminate"

  

#   metadata_options {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 1
#     instance_metadata_tags      = "enabled"
#   }

#   monitoring {
#     enabled = true
#   }
#   tags = local.common_tags

  
# }