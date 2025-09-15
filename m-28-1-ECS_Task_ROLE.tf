resource "aws_iam_role" "app3_task_role" {
  name = "app3-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy_document" "app3_secrets_read" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [local.secret_arn, "${local.secret_arn}*"]
  }
}

resource "aws_iam_policy" "app3_secrets_read" {
  name   = "app3-secrets-read"
  policy = data.aws_iam_policy_document.app3_secrets_read.json
}

resource "aws_iam_role_policy_attachment" "app3_task_attach_secrets" {
  role       = aws_iam_role.app3_task_role.name
  policy_arn = aws_iam_policy.app3_secrets_read.arn
}


resource "aws_iam_role_policy_attachment" "app3_exec_logs" {
  role       = aws_iam_role.app3_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}