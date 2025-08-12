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



output "ec2-instance_private-app1" {
  description = "The ID of the instance"
  value       = [for m in values (module.ec2-instance_private-app1): m.id]
}



output "ec2-instance_private_arn-app1" {
  description = "The ID of the instance"
  value       = [for m in values (module.ec2-instance_private-app1): m.arn]
}



output "ec2-instance_private-app2" {
  description = "The ID of the instance"
  value       = [for m in values (module.ec2-instance_private-app2): m.id]
}

output "ec2-instance_private_arn-app2" {
  description = "The ID of the instance"
  value       = [for m in values (module.ec2-instance_private-app2): m.arn]
}


# output "rds_endpoint" {
#   value = aws_db_instance.rds-database.endpoint
# }


