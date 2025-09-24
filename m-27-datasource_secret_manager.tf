data "aws_secretsmanager_secret" "db" {
  name = "dev/database_creds"
}

locals {
  secret_id = data.aws_secretsmanager_secret.db.arn
}

locals {
  secret_arn = data.aws_secretsmanager_secret.db.arn
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = local.secret_arn
}
locals {
  db = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db.secret_string))
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
  # expected keys from your screenshot:
  # username, password, engine, host, port, dbname, dbInstanceIdentifier
}

locals {
  db_secret_plain = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.db.secret_string))

  DB_USER = local.db_secret_plain.username
  DB_PASS = local.db_secret_plain.password
  DB_HOST = local.db_secret_plain.host
  DB_PORT = tostring(local.db_secret_plain.port)
  DB_NAME = local.db_secret_plain.dbname
}