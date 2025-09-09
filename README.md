# LNCR Database Infrastructure

Este repositório contém a infraestrutura como código (IaC) para provisionar e configurar o banco de dados PostgreSQL RDS na AWS para o projeto LNCR.

## Arquitetura

- **RDS PostgreSQL 15.4** com gerenciamento automático de senha via AWS Secrets Manager
- **Security Group** configurado para acesso apenas da VPC (CIDR 10.1.0.0/16)
- **Subnet Group** existente (`lncr-prd-data-subnet-group`)
- **Execução automática** de scripts SQL para criação do schema
- **Suporte ao LocalStack** para desenvolvimento local

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
├── prd.tfvars          # Valores das variáveis para produção
├── docker-compose.yml   # Configuração do LocalStack
└── run-localstack.sh    # Script para executar LocalStack
```

## Pré-requisitos

### 1. Ferramentas Necessárias
```bash
# Terraform
terraform --version  # >= 1.0

# Docker e Docker Compose (para LocalStack)
docker --version
docker-compose --version

# PostgreSQL Client (para execução dos scripts SQL)
# Ubuntu/Debian
sudo apt-get install postgresql-client

# macOS
brew install postgresql
```

### 2. Recursos AWS Existentes (Produção)
- VPC com CIDR `10.1.0.0/16`
- DB Subnet Group com nome `lncr-prd-data-subnet-group`
- Credenciais AWS configuradas

### 3. LocalStack (Desenvolvimento)
- Docker rodando na máquina local

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

### Desenvolvimento Local (LocalStack)


#### 1. Executar Script Automatizado
```bash
# Dar permissão de execução
chmod +x run-localstack.sh

# Executar LocalStack e Terraform
./run-localstack.sh
```

#### 2. Aplicar Infraestrutura Local
```bash
terraform apply -var-file="prd.tfvars"
```

#### 3. Verificar LocalStack
```bash
# Verificar RDS no LocalStack
aws --endpoint-url=http://localhost:4566 rds describe-db-instances

# Verificar Secrets no LocalStack
aws --endpoint-url=http://localhost:4566 secretsmanager list-secrets
```

### Produção (AWS Real)

#### 1. Configurar Credenciais AWS
```bash
aws configure
```

#### 2. Ajustar Provider
Remover endpoints do LocalStack do `provider.tf`:
```hcl
provider "aws" {
  region = "us-east-1"
}
```

#### 3. Inicializar Terraform
```bash
terraform init
```

#### 4. Planejar Deployment
```bash
terraform plan -var-file="prd.tfvars"
```

#### 5. Aplicar Infraestrutura
```bash
terraform apply -var-file="prd.tfvars"
```

#### 6. Verificar Deployment
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

## LocalStack

### O que é o LocalStack?
O LocalStack é uma plataforma que emula serviços da AWS localmente, permitindo desenvolvimento e testes sem custos.

### Configuração do LocalStack

#### docker-compose.yml
```yaml
version: '3.8'
services:
  localstack:
    container_name: localstack
    image: localstack/localstack:latest
    ports:
      - "4566:4566"
    environment:
      - SERVICES=ec2,rds,secretsmanager
      - LOCALSTACK_AUTH_TOKEN=${LOCALSTACK_AUTH_TOKEN}
      - DEBUG=1
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
```

#### Script run-localstack.sh
O script automatiza:
1. Para containers existentes
2. Remove containers conflitantes
3. Inicia LocalStack
4. Limpa cache do Terraform
5. Inicializa e valida Terraform
6. Executa terraform plan


### Alternativas para Desenvolvimento
```bash
# PostgreSQL local com Docker
docker run --name postgres-local \
  -e POSTGRES_PASSWORD=test \
  -p 5432:5432 -d postgres:15.4
```

## Troubleshooting

### LocalStack

#### Erro: Container name already in use
```bash
# Parar e remover containers
docker-compose down
docker rm -f localstack
```

#### Erro: RDS not available (501)
- RDS requer LocalStack Pro
- Verificar se `LOCALSTACK_AUTH_TOKEN` está configurado
- Confirmar que RDS está na lista de `SERVICES`

#### Erro: Provider configuration
- Verificar se endpoints estão configurados no `provider.tf`
- Confirmar que LocalStack está rodando na porta 4566

### AWS Produção

#### Erro de Conexão PostgreSQL
- Verificar se o `postgresql-client` está instalado
- Confirmar conectividade de rede com o RDS
- Validar credenciais no Secrets Manager

#### Scripts SQL Falhando
- Verificar sintaxe dos arquivos SQL
- Confirmar ordem de execução (1-5)
- Checar logs do Terraform para detalhes do erro

#### Erro de Credenciais AWS
```bash
# Configurar credenciais
aws configure

# Verificar credenciais
aws sts get-caller-identity
```