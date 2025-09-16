resource "aws_iam_role" "app3_exec_role" {
  name = "app3-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Standard: CloudWatch logs + image pull
resource "aws_iam_role_policy_attachment" "app3_exec_logs" {
  role       = aws_iam_role.app3_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# data "aws_iam_policy_document" "app3_exec_read_secret" {
#   statement {
#     actions   = ["secretsmanager:GetSecretValue"]
#     resources = [local.secret_arn, "${local.secret_arn}*"]
#   }
# }

# resource "aws_iam_policy" "app3_exec_read_secret" {
#   name   = "app3-exec-read-secret"
#   policy = data.aws_iam_policy_document.app3_exec_read_secret.json
# }

# Managed policy gives CloudWatch Logs + ECR pull (ECR part is harmless if you use Docker Hub)
# resource "aws_iam_role_policy_attachment" "app3_exec_attach_secret" {
#   role       = aws_iam_role.app3_exec_role.name
#   policy_arn = aws_iam_policy.app3_exec_read_secret.arn
# }