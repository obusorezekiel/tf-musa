resource "aws_security_group" "aurora" {
  name        = "${var.environment}-aurora-sg"
  description = "Security group for Aurora RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = [var.subnet_id]
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "${var.environment}-aurora-cluster"
  engine                = "aurora-postgresql"
  engine_version        = var.engine_version
  database_name         = var.database_name
  master_username       = var.master_username
  master_password       = var.master_password
  skip_final_snapshot   = true
  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name  = aws_db_subnet_group.aurora.name
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "${var.environment}-aurora-instance"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
}