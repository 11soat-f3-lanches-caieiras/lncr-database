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

# Recurso para validar se o banco está acessível e pronto
resource "null_resource" "validate_database" {
  provisioner "local-exec" {
    command = <<-EOT
      timeout=300
      interval=10
      elapsed=0

      echo "Validating database connection..."
      while [ $elapsed -lt $timeout ]; do
        PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
        psql -h ${aws_db_instance.postgresql.address} \
             -p 5432 \
             -U ${aws_db_instance.postgresql.username} \
             -d ${aws_db_instance.postgresql.db_name} \
             -c "SELECT 1;" > /dev/null 2>&1

        if [ $? -eq 0 ]; then
          echo "Database connection successful!"
          break
        fi

        echo "Waiting for database to be ready... ($elapsed/$timeout seconds)"
        sleep $interval
        elapsed=$((elapsed + interval))
      done

      if [ $elapsed -ge $timeout ]; then
        echo "Database connection timeout!"
        exit 1
      fi
    EOT
  }

  depends_on = [aws_db_instance.postgresql]

  triggers = {
    db_instance_id = aws_db_instance.postgresql.id
  }
}

# Script para verificar se o schema/estrutura já existe
resource "null_resource" "check_database_structure" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Checking if database structure exists..."

      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      table_count=$(psql -h ${aws_db_instance.postgresql.address} \
                         -p 5432 \
                         -U ${aws_db_instance.postgresql.username} \
                         -d ${aws_db_instance.postgresql.db_name} \
                         -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';")

      echo "Found $table_count tables in the database"

      if [ "$table_count" -eq "0" ]; then
        echo "Database structure not found. Scripts will be executed."
        echo "execute_scripts=true" > /tmp/db_check_result.txt
      else
        echo "Database structure already exists. Skipping script execution."
        echo "execute_scripts=false" > /tmp/db_check_result.txt
      fi
    EOT
  }

  depends_on = [null_resource.validate_database]

  triggers = {
    always_check = timestamp()
  }
}

# Scripts SQL executados apenas se a estrutura não existir
resource "null_resource" "sql_scripts" {
  for_each = {
    "1-database-config" = "1-database-config.sql"
    "2-tables"          = "2-tables.sql"
    "3-constraints"     = "3-constraints.sql"
    "4-sequences"       = "4-sequences.sql"
    "5-indexes"         = "5-indexes.sql"
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Verificar se devemos executar os scripts
      if [ -f /tmp/db_check_result.txt ]; then
        execute_scripts=$(grep "execute_scripts=" /tmp/db_check_result.txt | cut -d'=' -f2)

        if [ "$execute_scripts" = "true" ]; then
          echo "Executing SQL script: ${each.value}"

          PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
          psql -h ${aws_db_instance.postgresql.address} \
               -p 5432 \
               -U ${aws_db_instance.postgresql.username} \
               -d ${aws_db_instance.postgresql.db_name} \
               -f ${path.root}/sql/${each.value}

          if [ $? -eq 0 ]; then
            echo "Successfully executed: ${each.value}"
          else
            echo "Error executing: ${each.value}"
            exit 1
          fi
        else
          echo "Skipping SQL script execution - database structure already exists"
        fi
      else
        echo "Database check result not found. Skipping script execution."
      fi
    EOT
  }

  depends_on = [null_resource.check_database_structure]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/${each.value}")
  }
}