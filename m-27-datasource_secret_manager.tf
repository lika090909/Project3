data "aws_secretsmanager_secret" "db" {
  name = "dev/database_creds"  
}

locals {
  secret_id = data.aws_secretsmanager_secret.db.arn
}