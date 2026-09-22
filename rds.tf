resource "aws_db_subnet_group" "postgres" {
  name = "${var.cluster_name}-postgres-subnet-group"

  subnet_ids = module.vpc.private_subnets

  tags = {
    Name        = "${var.cluster_name}-postgres-subnet-group"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_security_group" "rds_postgres" {
  name        = "${var.cluster_name}-rds-postgres-sg"
  description = "Security group for private RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "PostgreSQL from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["sg-0c51e190ae42af893"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-rds-postgres-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}
resource "aws_db_instance" "postgres" {
  identifier = "${var.cluster_name}-postgres"

  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "appdb"
  username = "appadmin"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds_postgres.id]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 1

  deletion_protection = false

  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name        = "${var.cluster_name}-postgres"
    Environment = var.environment
    Terraform   = "true"
  }
}