output "db_instance_endpoint" {
  description = "Endpoint da instância RDS"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.postgresql.id
}

output "db_instance_arn" {
  description = "ARN da instância RDS"
  value       = aws_db_instance.postgresql.arn
}

output "security_group_id" {
  description = "ID do security group do RDS"
  value       = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "ARN do secret gerado automaticamente para o usuário master"
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
}