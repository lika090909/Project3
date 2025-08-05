output "ec2-instance_bastion-az1_id" {
  description = "The ID of the instance"
  value       = module.ec2-instance_bastion-az1.id
}

output "ec2-instance_bastion-az1_public_ip" {
  description = "The ID of the instance"
  value       = module.ec2-instance_bastion-az1.public_ip
}

output "ec2-instance_bastion-az1_arn" {
  description = "The ID of the instance"
  value       = module.ec2-instance_bastion-az1.arn
}

# output "ec2-instance_bastion-az2_id" {
#   description = "The ID of the instance"
#   value       = module.ec2-instance_bastion-az2.id
# }

# output "ec2-instance_bastion-az2_public_ip" {
#   description = "The ID of the instance"
#   value       = module.ec2-instance_bastion-az2.public_ip
# }

# output "ec2-instance_bastion-az2_arn" {
#   description = "The ID of the instance"
#   value       = module.ec2-instance_bastion-az2.arn
# }


output "ec2-instance_private_az1" {
  description = "The ID of the instance"
  value       = module.ec2-instance_private_az1.id
}


output "ec2-instance_private_az2" {
  description = "The ID of the instance"
  value       = module.ec2-instance_private_az2.id
}

output "ec2-instance_private_az1_arn" {
  description = "The ID of the instance"
  value       = module.ec2-instance_private_az1.arn
}

output "ec2-instance_private_az2_arn" {
  description = "The ID of the instance"
  value       = module.ec2-instance_private_az2.arn
}

# output "rds_endpoint" {
#   value = aws_db_instance.rds-database.endpoint
# }


