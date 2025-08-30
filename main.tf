module "rds_postgresql" {
  source = "./modules/rds-postegresql"

  db_name          = var.db_name
  db_username      = var.db_username

  vpc_id           = data.aws_vpc.main.id
  instance_class   = var.instance_class
  allocated_storage = var.allocated_storage
  environment      = var.environment
  prefix_name      = var.prefix_name
}