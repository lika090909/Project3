
# resource "aws_eip" "nat" {
#   for_each = local.az_keys
#   domain   = "vpc"
#   tags     = { Name = "nat-eip-${each.key}" }
# }



# resource "aws_eip" "ec2_bastion-az1" {
#   depends_on = [ module.ec2-instance_bastion-az1]
#   instance = module.ec2-instance_bastion-az1.id
#   domain   = "vpc"

# }

# # resource "aws_eip" "ec2_bastion-az2" {
# #   depends_on = [ module.ec2-instance_bastion-az2]
# #   instance = module.ec2-instance_bastion-az2.id
# #   domain   = "vpc"

# # }


