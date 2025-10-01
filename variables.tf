variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "lncr-db"
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "lncr-app"
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t4g.small"
}

variable "allocated_storage" {
  description = "Storage alocado em GB"
  type        = number
  default     = 50
}

variable "environment" {
  description = "Ambiente (dev, stg, prod)"
  type        = string
  default     = "prd"
}

variable "prefix_name" {
  description = "Prefixo para nomes dos recursos"
  type        = string
  default     = "lncr"
}
