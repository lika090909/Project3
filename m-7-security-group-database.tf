module "security-group_database" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name   = "RDS-SG"
  vpc_id = module.vpc.vpc_id

  # ✅ Allow MySQL only from ECS tasks
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = aws_security_group.ecs_task_sg.id
    }
  ]

  egress_rules = ["all-all"]

  tags = local.common_tags
}