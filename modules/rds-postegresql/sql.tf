terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.21"
    }
  }
}

provider "postgresql" {
  host            = aws_db_instance.postgresql.address
  port            = 5432
  database        = aws_db_instance.postgresql.db_name
  username        = aws_db_instance.postgresql.username
  password        = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
  sslmode         = "require"
  connect_timeout = 15
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_db_instance.postgresql.master_user_secret[0].secret_arn
}

resource "postgresql_database" "app_database" {
  name  = var.db_name
  owner = aws_db_instance.postgresql.username

  depends_on = [aws_db_instance.postgresql]
}

resource "null_resource" "sql_scripts" {
  for_each = {
    "1-database-config" = file("${path.root}/sql/1-database-config.sql")
    "2-tables"          = file("${path.root}/sql/2-tables.sql")
    "3-constraints"     = file("${path.root}/sql/3-constraints.sql")
    "4-sequences"       = file("${path.root}/sql/4-sequences.sql")
    "5-indexes"         = file("${path.root}/sql/5-indexes.sql")
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -f ${path.root}/sql/${each.key}.sql
    EOT
  }

  depends_on = [
    aws_db_instance.postgresql,
    postgresql_database.app_database
  ]

  triggers = {
    sql_content = each.value
  }
}