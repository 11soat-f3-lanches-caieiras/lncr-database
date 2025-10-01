variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "postgres"
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage alocado em GB"
  type        = number
  default     = 20
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
