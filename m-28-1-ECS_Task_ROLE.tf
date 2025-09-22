
# --- Allow the task to read your Secrets Manager secret ---
data "aws_iam_policy_document" "app3_secrets_read" {
  statement {
    sid    = "ReadSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      data.aws_secretsmanager_secret.db.arn,      # exact ARN
      "${data.aws_secretsmanager_secret.db.arn}*" # covers versioned ARNs
    ]
  }

  # If the secret uses a customer-managed KMS key, UNCOMMENT and set your key ARN:
  # statement {
  #   sid     = "KmsDecrypt"
  #   effect  = "Allow"
  #   actions = ["kms:Decrypt"]
  #   resources = ["arn:aws:kms:us-east-1:058264231384:key/<YOUR_KEY_ID>"]
  # }
}

resource "aws_iam_policy" "app3_secrets_read" {
  name   = "app3-secrets-read"
  policy = data.aws_iam_policy_document.app3_secrets_read.json
}

# --- ECS task role (trusted by ecs-tasks.amazonaws.com) ---
resource "aws_iam_role" "app3_task_role" {
  name = "app3-task-role" # keep this OR rename to "app3-service" if you prefer
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach the policy to the task role
resource "aws_iam_role_policy_attachment" "app3_task_attach_secrets" {
  role       = aws_iam_role.app3_task_role.name
  policy_arn = aws_iam_policy.app3_secrets_read.arn
}



# data "aws_iam_policy_document" "app3_secrets_read" {
#   statement {
#     sid     = "ReadDBSecret"
#     actions = ["secretsmanager:GetSecretValue"]
#     resources = [
#       data.aws_secretsmanager_secret.db.arn,
#       "${data.aws_secretsmanager_secret.db.arn}*"
#     ]
#   }
# }

# resource "aws_iam_policy" "app3_secrets_read" {
#   name   = "app3-secrets-read"
#   policy = data.aws_iam_policy_document.app3_secrets_read.json
# }

# resource "aws_iam_role" "app3_task_role" {
#   name = "app3-task-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = { Service = "ecs-tasks.amazonaws.com" },
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "app3_task_attach_secrets" {
#   role       = aws_iam_role.app3_task_role.name
#   policy_arn = aws_iam_policy.app3_secrets_read.arn
# }
