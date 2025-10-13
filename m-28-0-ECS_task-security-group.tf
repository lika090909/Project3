resource "aws_security_group" "ecs_task_sg" {
  name   = "${var.environment}-ecs-task-sg"
  vpc_id = module.vpc.vpc_id

  # app1/app2 on 80
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_cf_ingress.id] # 👈 updated
    description     = "ALB to ECS on 80"
  }

  # app3 on 8080 (separate rule)
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_cf_ingress.id] # 👈 updated
    description     = "ALB to ECS on 8080"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
