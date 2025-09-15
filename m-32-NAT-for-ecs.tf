# locals {
#   az_keys = toset([for i in range(length(module.vpc.public_subnets)) : tostring(i)])
# }

# resource "aws_nat_gateway" "ecs" {
#   for_each      = local.az_keys
#   allocation_id = aws_eip.nat[each.key].id
#   subnet_id     = module.vpc.public_subnets[tonumber(each.key)]
#   tags          = { Name = "nat-${each.key}" }
#   depends_on    = [module.vpc]
# }
# resource "aws_route" "ecs" {
#   for_each               = local.az_keys
#   route_table_id         = module.vpc.private_route_table_ids[tonumber(each.key)]
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.ecs[each.key].id
# }