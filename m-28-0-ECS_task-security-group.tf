#######################################
# ECS Task Security Group
#######################################
resource "aws_security_group" "ecs_task_sg" {
  name   = "${var.environment}-ecs-task-sg"
  vpc_id = module.vpc.vpc_id

  # Allow inbound traffic from ALB HTTPS and App3 SGs
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_http_sg.id]
    description     = "Allow ALB HTTPS SG to reach ECS port 80"
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_8080_sg.id]
    description     = "Allow ALB App3 SG to reach ECS port 8080"
  }

  # Allow ECS tasks to reach out to the internet / other services
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
