resource "aws_db_instance" "rds_database" {

  identifier        = var.instance_identifier
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = true

  #kms_key_id        = var.kms_key_id
  db_name                             = var.db_name
  username                            = var.db_username
  password                            = var.db_password
  port                                = 3306
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.security-group_database.security_group_id]
  db_subnet_group_name                = module.vpc.database_subnet_group
  #availability_zone      = element(module.vpc.azs, 0)
  multi_az            = true
  skip_final_snapshot = true
  publicly_accessible = false

}


