resource "aws_security_group" "rds" {
  name_prefix = "${var.prefix_name}-${var.environment}-rds"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "postgresql" {
  identifier             = "${var.prefix_name}-${var.environment}-postgresql"
  engine                 = "postgres"
  engine_version         = "15.12"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp3"
  
  db_name  = var.db_name
  username = var.db_username
  manage_master_user_password = true
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = data.aws_db_subnet_group.main.name
  
  skip_final_snapshot = true
  
  tags = {
    Name        = "${var.prefix_name}-${var.environment}-postgresql"
    Environment = var.environment
  }
}