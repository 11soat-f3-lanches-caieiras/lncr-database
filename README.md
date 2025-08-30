# LNCR Database Infrastructure

Este repositório contém a infraestrutura como código (IaC) para provisionar e configurar o banco de dados PostgreSQL RDS na AWS para o projeto LNCR.

## Arquitetura

- **RDS PostgreSQL 15.4** com gerenciamento automático de senha via AWS Secrets Manager
- **Security Group** configurado para acesso apenas da VPC (CIDR 10.1.0.0/16)
- **Subnet Group** existente (`lncr-prd-data-subnet-group`)
- **Execução automática** de scripts SQL para criação do schema

## Estrutura do Projeto

```
lncr-database/
├── modules/
│   └── rds-postegresql/
│       ├── main.tf          # Recursos RDS, Security Group
│       ├── sql.tf           # Provider PostgreSQL e execução de scripts
│       ├── variables.tf     # Variáveis do módulo
│       └── outputs.tf       # Outputs do módulo
├── sql/
│   ├── 1-database-config.sql    # Configurações do banco
│   ├── 2-tables.sql             # Criação de tabelas
│   ├── 3-constraints.sql        # Primary Keys, Foreign Keys, Unique
│   ├── 4-sequences.sql          # Sequences e Identity columns
│   └── 5-indexes.sql            # Índices para performance
├── main.tf              # Chamada do módulo
├── data.tf              # Data sources (VPC)
├── variables.tf         # Variáveis root
├── provider.tf          # Configuração do provider AWS
└── prd.tfvars          # Valores das variáveis para produção
```

## Pré-requisitos

### 1. Ferramentas Necessárias
```bash
# Terraform
terraform --version  # >= 1.0

# PostgreSQL Client (para execução dos scripts SQL)
# Ubuntu/Debian
sudo apt-get install postgresql-client

# macOS
brew install postgresql
```

### 2. Recursos AWS Existentes
- VPC com CIDR `10.1.0.0/16`
- DB Subnet Group com nome `lncr-prd-data-subnet-group`
- Credenciais AWS configuradas

## Configuração

### 1. Variáveis de Ambiente (prd.tfvars)
```hcl
db_name          = "lncr_database"
db_username      = "postgres"
instance_class   = "db.t4g.small"
allocated_storage = 20
environment      = "prd"
prefix_name      = "lncr"
```

### 2. Recursos Criados
- **RDS Instance**: `lncr-prd-postgresql`
- **Security Group**: `lncr-prd-rds-sg`
- **Secret Manager**: Senha gerenciada automaticamente pelo RDS
- **Schema Completo**: Tabelas, constraints, sequences e indexes

## Deploy

### 1. Inicializar Terraform
```bash
terraform init
```

### 2. Planejar Deployment
```bash
terraform plan -var-file="prd.tfvars"
```

### 3. Aplicar Infraestrutura
```bash
terraform apply -var-file="prd.tfvars"
```

### 4. Verificar Deployment
```bash
# Verificar RDS
aws rds describe-db-instances --db-instance-identifier lncr-prd-postgresql

# Verificar Secret
aws secretsmanager list-secrets --filters Key=name,Values=rds-db-credentials
```

## Funcionalidades

### Gerenciamento de Senha
- Senha gerada automaticamente pelo RDS
- Armazenada no AWS Secrets Manager
- Rotação automática disponível

### Execução de Scripts SQL
Os scripts SQL são executados automaticamente na seguinte ordem:
1. **database-config.sql**: Configurações do PostgreSQL
2. **tables.sql**: Criação de todas as tabelas
3. **constraints.sql**: Primary Keys, Foreign Keys, Unique constraints
4. **sequences.sql**: Identity columns e sequences
5. **indexes.sql**: Índices para otimização de performance

### Security Group
- **Ingress**: Porta 5432 apenas do CIDR 10.1.0.0/16
- **Egress**: Liberado para internet (0.0.0.0/0)

## Outputs

Após o deployment, os seguintes outputs estarão disponíveis:
- `db_instance_endpoint`: Endpoint de conexão do RDS
- `db_instance_id`: ID da instância RDS
- `db_instance_arn`: ARN da instância RDS
- `security_group_id`: ID do Security Group
- `master_user_secret_arn`: ARN do secret com a senha

## Conexão ao Banco

### Via psql
```bash
# Obter senha do Secrets Manager
aws secretsmanager get-secret-value --secret-id <secret-arn> --query SecretString --output text

# Conectar
psql -h <endpoint> -p 5432 -U postgres -d lncr_database
```

### String de Conexão
```
postgresql://postgres:<password>@<endpoint>:5432/lncr_database
```

## Limpeza

Para destruir toda a infraestrutura:
```bash
terraform destroy -var-file="prd.tfvars"
```

## Troubleshooting

### Erro de Conexão PostgreSQL
- Verificar se o `postgresql-client` está instalado
- Confirmar conectividade de rede com o RDS
- Validar credenciais no Secrets Manager

### Scripts SQL Falhando
- Verificar sintaxe dos arquivos SQL
- Confirmar ordem de execução (1-5)
- Checar logs do Terraform para detalhes do erro