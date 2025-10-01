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

# Scripts SQL executados em ordem sequencial
resource "null_resource" "sql_script_1_config" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Executing SQL script: 1-database-config.sql"

      # Verificar se o arquivo existe
      if [ ! -f "${path.root}/sql/1-database-config.sql" ]; then
        echo "ERROR: SQL file ${path.root}/sql/1-database-config.sql not found!"
        exit 1
      fi

      # Executar o script SQL com tratamento de erro melhorado
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -v ON_ERROR_STOP=1 \
           -f ${path.root}/sql/1-database-config.sql

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
        echo "Successfully executed: 1-database-config.sql"
      else
        echo "Error executing: 1-database-config.sql (exit code: $exit_code)"
        exit $exit_code
      fi
    EOT
  }

  depends_on = [null_resource.validate_database]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/1-database-config.sql")
    db_instance_id = aws_db_instance.postgresql.id
  }
}

resource "null_resource" "sql_script_2_tables" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Executing SQL script: 2-tables.sql"

      # Verificar se o arquivo existe
      if [ ! -f "${path.root}/sql/2-tables.sql" ]; then
        echo "ERROR: SQL file ${path.root}/sql/2-tables.sql not found!"
        exit 1
      fi

      # Executar o script SQL com tratamento de erro melhorado
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -v ON_ERROR_STOP=1 \
           -f ${path.root}/sql/2-tables.sql

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
        echo "Successfully executed: 2-tables.sql"
      else
        echo "Error executing: 2-tables.sql (exit code: $exit_code)"
        exit $exit_code
      fi
    EOT
  }

  depends_on = [null_resource.sql_script_1_config]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/2-tables.sql")
    db_instance_id = aws_db_instance.postgresql.id
  }
}

resource "null_resource" "sql_script_3_constraints" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Executing SQL script: 3-constraints.sql"

      # Verificar se o arquivo existe
      if [ ! -f "${path.root}/sql/3-constraints.sql" ]; then
        echo "ERROR: SQL file ${path.root}/sql/3-constraints.sql not found!"
        exit 1
      fi

      # Executar o script SQL com tratamento de erro melhorado
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -v ON_ERROR_STOP=1 \
           -f ${path.root}/sql/3-constraints.sql

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
        echo "Successfully executed: 3-constraints.sql"
      else
        echo "Error executing: 3-constraints.sql (exit code: $exit_code)"
        exit $exit_code
      fi
    EOT
  }

  depends_on = [null_resource.sql_script_2_tables]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/3-constraints.sql")
    db_instance_id = aws_db_instance.postgresql.id
  }
}

resource "null_resource" "sql_script_4_sequences" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Executing SQL script: 4-sequences.sql"

      # Verificar se o arquivo existe
      if [ ! -f "${path.root}/sql/4-sequences.sql" ]; then
        echo "ERROR: SQL file ${path.root}/sql/4-sequences.sql not found!"
        exit 1
      fi

      # Executar o script SQL com tratamento de erro melhorado
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -v ON_ERROR_STOP=1 \
           -f ${path.root}/sql/4-sequences.sql

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
        echo "Successfully executed: 4-sequences.sql"
      else
        echo "Error executing: 4-sequences.sql (exit code: $exit_code)"
        exit $exit_code
      fi
    EOT
  }

  depends_on = [null_resource.sql_script_3_constraints]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/4-sequences.sql")
    db_instance_id = aws_db_instance.postgresql.id
  }
}

resource "null_resource" "sql_script_5_indexes" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Executing SQL script: 5-indexes.sql"

      # Verificar se o arquivo existe
      if [ ! -f "${path.root}/sql/5-indexes.sql" ]; then
        echo "ERROR: SQL file ${path.root}/sql/5-indexes.sql not found!"
        exit 1
      fi

      # Executar o script SQL com tratamento de erro melhorado
      PGPASSWORD='${jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]}' \
      psql -h ${aws_db_instance.postgresql.address} \
           -p 5432 \
           -U ${aws_db_instance.postgresql.username} \
           -d ${aws_db_instance.postgresql.db_name} \
           -v ON_ERROR_STOP=1 \
           -f ${path.root}/sql/5-indexes.sql

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
        echo "Successfully executed: 5-indexes.sql"
      else
        echo "Error executing: 5-indexes.sql (exit code: $exit_code)"
        exit $exit_code
      fi
    EOT
  }

  depends_on = [null_resource.sql_script_4_sequences]

  triggers = {
    sql_file_hash = filemd5("${path.root}/sql/5-indexes.sql")
    db_instance_id = aws_db_instance.postgresql.id
  }
}