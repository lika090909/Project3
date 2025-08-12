output "private-app1-az1" {
  value = module.ec2-instance_private-app1[0].id
}

output "private-app1-az2" {
  value = module.ec2-instance_private-app1[1].id
}

output "private-app2-az1" {
  value = module.ec2-instance_private-app2[0].id
}


output "private-app2-az2" {
  value = module.ec2-instance_private-app2[1].id
}