output "db_instance_endpoint" {
  description = "Endpoint da instância RDS"
  value       = module.rds_postgresql.db_instance_endpoint
}

output "db_instance_id" {
  description = "ID da instância RDS"
  value       = module.rds_postgresql.db_instance_id
}

output "db_instance_arn" {
  description = "ARN da instância RDS"
  value       = module.rds_postgresql.db_instance_arn
}

output "security_group_id" {
  description = "ID do security group do RDS"
  value       = module.rds_postgresql.security_group_id
}

output "master_user_secret_arn" {
  description = "ARN do secret gerado automaticamente para o usuário master"
  value       = module.rds_postgresql.master_user_secret_arn
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = var.db_name
}

output "db_instance_username" {
  description = "Username do banco de dados"
  value       = var.db_username
}
