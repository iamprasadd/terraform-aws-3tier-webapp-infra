resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "${var.project}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.project}-${var.environment}-db-params"
  family = "mysql8.0"

}

resource "aws_db_instance" "this" {
  identifier              = "${var.project}-${var.environment}-db-instance"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  multi_az                = var.multi_az
  storage_encrypted       = var.storage_encrypted
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  parameter_group_name    = aws_db_parameter_group.this.name
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  tags = {
    Name = "${var.project}-${var.environment}-db-instance"
  }
}

