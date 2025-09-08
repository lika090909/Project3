# resource "aws_iam_role" "ec2_role" {
#   name = "ec2-secrets-reader"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = { Service = "ec2.amazonaws.com" },
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_policy" "secrets_read" {
#   name   = "secrets-read-db"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = ["secretsmanager:GetSecretValue"],
#       Resource = data.aws_secretsmanager_secret.db.arn
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.secrets_read.arn
# }

# resource "aws_iam_instance_profile" "ec2_profile" {
#   name = "ec2-secrets-reader-profile"
#   role = aws_iam_role.ec2_role.name
# }