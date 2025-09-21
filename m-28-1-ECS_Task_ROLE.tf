

data "aws_iam_policy_document" "app3_secrets_read" {
  statement {
    sid     = "ReadDBSecret"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      data.aws_secretsmanager_secret.db.arn,
      "${data.aws_secretsmanager_secret.db.arn}*"
    ]
  }
}

resource "aws_iam_policy" "app3_secrets_read" {
  name   = "app3-secrets-read"
  policy = data.aws_iam_policy_document.app3_secrets_read.json
}

resource "aws_iam_role" "app3_task_role" {
  name = "app3-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "app3_task_attach_secrets" {
  role       = aws_iam_role.app3_task_role.name
  policy_arn = aws_iam_policy.app3_secrets_read.arn
}
