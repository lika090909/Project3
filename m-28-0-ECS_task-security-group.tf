# ECS Task SG for APP1 and APP2 (on port 80)

resource "aws_security_group" "ecs_task_sg" {
  name   = "${var.environment}-ecs-task-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb_SG.security_group_id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ECS Task SG for APP3 (on port 8080)

resource "aws_security_group_rule" "alb_to_task_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_task_sg.id
  source_security_group_id = module.alb_SG.security_group_id
  description              = "ALB to ECS tasks on 8080"
}
