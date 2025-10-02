[![Deploy Database Infrastructure](https://github.com/11soat-f3-lanches-caieiras/lncr-database/actions/workflows/deploy-database.yml/badge.svg?branch=develop)](https://github.com/11soat-f3-lanches-caieiras/lncr-database/actions/workflows/deploy-database.yml)

# 🗄️ LNCR Database Infrastructure

Este repositório implementa a infraestrutura completa de banco de dados PostgreSQL para o sistema LNCR (Lanchonete) utilizando Infrastructure as Code (IaC) com Terraform. A solução provisiona automaticamente RDS PostgreSQL, Security Groups, AWS Secrets Manager e executa scripts SQL para criação do schema completo.

> **📚 Contexto Acadêmico**: Este repositório faz parte dos entregáveis do trabalho da **Fase 3** do curso de **Pós-graduação em Software Architecture** da **FIAP**, demonstrando a aplicação prática de conceitos de infraestrutura como código, gerenciamento de banco de dados e automação de deploy em ambiente cloud-native.

## 📋 Índice

- [Visão Geral da Arquitetura](#-visão-geral-da-arquitetura)
- [Recursos Provisionados](#-recursos-provisionados)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Schema do Banco de Dados](#-schema-do-banco-de-dados)
- [Pré-requisitos](#-pré-requisitos)
- [Início Rápido](#-início-rápido)
- [Pipeline CI/CD](#-pipeline-cicd)
- [Configuração Detalhada](#-configuração-detalhada)
- [Conexão ao Banco](#-conexão-ao-banco)
- [Testes e Validação](#-testes-e-validação)
- [Monitoramento](#-monitoramento)
- [Segurança](#-segurança)
- [Troubleshooting](#-troubleshooting)
- [Custos](#-custos)
- [Contribuição](#-contribuição)

## 🏗️ Visão Geral da Arquitetura

A infraestrutura de banco de dados foi projetada seguindo as melhores práticas de segurança, escalabilidade e alta disponibilidade:

```
┌─────────────────────────────────────────────────────────────────┐
│                           AWS Cloud                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌──────────────────────────────────────┐ │
│  │  Secrets Manager  │    │            VPC Network              │ │
│  │  (Credentials)    │    │  ┌─────────────┐  ┌─────────────────┐│ │
│  └─────────────────┘    │  │   Public    │  │    Private      ││ │
│                         │  │   Subnets   │  │    Subnets      ││ │
│  ┌─────────────────┐    │  │             │  │                 ││ │
│  │   PostgreSQL    │    │  │  NAT Gateway │  │   EKS Cluster   ││ │
│  │   Provider      │    │  │   + IGW      │  │   + Apps        ││ │
│  └─────────────────┘    │  └─────────────┘  └─────────────────┘│ │
│                         │                                      │ │
│  ┌─────────────────┐    │  ┌─────────────┐  ┌─────────────────┐│ │
│  │   GitHub        │    │  │    Data     │  │ RDS PostgreSQL  ││ │
│  │   Actions       │    │  │   Subnets   │  │   15.12 + SG     ││ │
│  └─────────────────┘    │  └─────────────┘  └─────────────────┘│ │
│                         └──────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🚀 Recursos Provisionados

### Componentes Principais

#### 1. **Amazon RDS PostgreSQL 15.12**
- Instância gerenciada com alta disponibilidade
- Backup automático e janelas de manutenção configuráveis
- Monitoramento integrado via CloudWatch
- Gerenciamento automático de patches de segurança

#### 2. **AWS Secrets Manager**
- Geração automática de senhas seguras
- Rotação automática de credenciais (configurável)
- Criptografia em repouso e em trânsito
- Integração nativa com RDS

#### 3. **Security Group Dedicado**
- Acesso restrito apenas da VPC interna (CIDR 10.1.0.0/16)
- Porta 5432 (PostgreSQL) configurada especificamente
- Regras de egress controladas

#### 4. **Subnet Group Existente**
- Utiliza subnet group pré-configurado: `lncr-prd-data-subnet-group`
- Distribuição em múltiplas AZs para alta disponibilidade
- Isolamento de rede para camada de dados

#### 5. **Execução Automática de Scripts SQL**
- Pipeline automatizado de criação do schema
- Ordem sequencial garantida (1-5)
- Validação de integridade pós-execução

## 📁 Estrutura do Projeto

```
lncr-database/
├── .github/
│   └── workflows/
│       └── deploy-database.yml     # Pipeline CI/CD GitHub Actions
├── modules/
│   └── rds-postegresql/
│       ├── data.tf                 # Data sources (VPC, Subnet Group)
│       ├── main.tf                 # Recursos principais (RDS, Security Group)
│       ├── outputs.tf              # Outputs do módulo
│       ├── sql.tf                  # Provider PostgreSQL e execução SQL
│       └── variables.tf            # Variáveis de entrada do módulo
├── sql/
│   ├── 1-database-config.sql       # Configurações PostgreSQL
│   ├── 2-tables.sql                # Definição de tabelas
│   ├── 3-constraints.sql           # Chaves primárias e estrangeiras
│   ├── 4-sequences.sql             # Sequences e colunas identity
│   └── 5-indexes.sql               # Índices para otimização
├── .gitignore                      # Exclusões do Git
├── data.tf                         # Data sources root (VPC)
├── main.tf                         # Chamada do módulo principal
├── prd.tfvars                      # Variáveis de produção
├── provider.tf                     # Configuração providers AWS/PostgreSQL
├── README.md                       # Esta documentação
└── variables.tf                    # Variáveis root do projeto
```

---

## 🗄️ Schema do Banco de Dados

### Modelo de Dados Completo

O sistema LNCR implementa um modelo de dados robusto para gerenciamento completo de uma lanchonete, incluindo:

#### **Entidades Principais:**

1. **Customer (Clientes)**
   - Gestão de clientes com CPF e email
   - Histórico de pedidos vinculado

2. **Food Item (Itens do Cardápio)**
   - Catálogo completo de produtos
   - Categorização e precificação
   - Suporte a múltiplas imagens por item

3. **Customer Order (Pedidos)**
   - Controle completo do ciclo de vida dos pedidos
   - Rastreamento de status e timestamps
   - Cálculo automático de totais

4. **Kitchen Order (Pedidos da Cozinha)**
   - Separação entre pedido comercial e produção
   - Controle independente de status da cozinha
   - Otimização do fluxo de preparo

5. **Payment (Pagamentos)**
   - Múltiplos métodos de pagamento
   - Integração com provedores externos (MercadoPago)
   - Rastreamento completo de transações

6. **Notifications (Notificações)**
   - Sistema de notificações em tempo real
   - Suporte a diferentes tipos de eventos
   - Rastreabilidade de comunicações

#### **Relacionamentos:**
- Customer → Customer Order (1:N)
- Customer Order → Customer Order Food Item (1:N)
- Food Item → Customer Order Food Item (1:N)
- Customer Order → Kitchen Order (1:1)
- Kitchen Order → Kitchen Order Food Item (1:N)
- Customer Order → Payment (1:N)
- Food Item → Food Item Image (1:N)

## 🔧 Pré-requisitos

### Software Necessário

#### Terraform
```bash
# Instalação via Chocolatey (Windows)
choco install terraform

# Instalação via Homebrew (macOS)
brew install terraform

# Verificação da versão
terraform --version  # Requerido: >= 1.5.0
```

#### AWS CLI
```bash
# Instalação Windows
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Instalação macOS
brew install awscli

# Configuração
aws configure
```

#### PostgreSQL Client
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install postgresql-client-15

# CentOS/RHEL
sudo dnf install postgresql15

# macOS
brew install postgresql@15

# Windows
# Download do site oficial: https://www.postgresql.org/download/windows/
```

#### Docker (Para desenvolvimento local)
```bash
# Verificação
docker --version
docker-compose --version
```

### 2. **Recursos AWS Pré-existentes**

#### VPC Configuration
- **VPC ID:** Deve existir com CIDR `10.1.0.0/16`
- **Subnets:** Mínimo 2 subnets em AZs diferentes
- **Internet Gateway:** Para acesso externo (se necessário)
- **Route Tables:** Configuradas adequadamente

#### DB Subnet Group
- **Nome:** `lncr-prd-data-subnet-group`
- **Subnets:** Distribuídas em pelo menos 2 AZs
- **Configuração:** Adequada para RDS PostgreSQL

#### IAM Permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:*",
        "secretsmanager:*",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:CreateSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🚀 Início Rápido

### 1. Clone o Repositório
```bash
git clone https://github.com/11soat-f3-lanches-caieiras/lncr-database.git
cd lncr-database
```

### 2. Configure Credenciais AWS
```bash
# Configure suas credenciais AWS
aws configure

# Ou use variáveis de ambiente
export AWS_ACCESS_KEY_ID="sua-access-key"
export AWS_SECRET_ACCESS_KEY="sua-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Inicialize o Terraform
```bash
terraform init
```

### 4. Valide a Configuração
```bash
terraform validate
terraform fmt
```

### 5. Planeje a Implantação
```bash
terraform plan -var-file="prd.tfvars"
```

### 6. Aplique a Infraestrutura
```bash
terraform apply -var-file="prd.tfvars"
```

### 7. Configure Conexão ao Banco
```bash
# Obter credenciais
SECRET_ARN=$(terraform output -raw master_user_secret_arn)
PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id $SECRET_ARN \
  --query SecretString --output text | jq -r .password)
ENDPOINT=$(terraform output -raw db_instance_endpoint)

# Testar conexão
psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database
```

---

## ⚙️ Configuração Detalhada

### 1. **Variáveis de Ambiente (prd.tfvars)**

```hcl
# Configurações do Banco de Dados
db_name          = "lncr_database"
db_username      = "postgres"

# Configurações da Instância
instance_class   = "db.t4g.small"    # 2 vCPU, 2 GB RAM
allocated_storage = 20                # 20 GB SSD gp3

# Configurações do Ambiente
environment      = "prd"
prefix_name      = "lncr"
```

### 2. **Recursos Provisionados**

#### RDS Instance
- **Identificador:** `lncr-prd-postgresql`
- **Engine:** PostgreSQL 15.12
- **Classe:** db.t4g.small (ARM-based, otimizado para custo)
- **Storage:** 20 GB gp3 (SSD de alta performance)
- **Multi-AZ:** Configurável (recomendado para produção)

#### Security Group
- **Nome:** `lncr-prd-rds-sg`
- **Ingress:** Porta 5432 apenas do CIDR 10.1.0.0/16
- **Egress:** Liberado para 0.0.0.0/0 (atualizações e patches)

#### Secrets Manager
- **Geração:** Automática pelo RDS
- **Rotação:** Configurável (30, 60, 90 dias)
- **Criptografia:** AWS KMS (chave padrão)

---

## 🚀 Guia de Deploy

### **Desenvolvimento Local**

#### Opção 1: PostgreSQL Local com Docker
```bash
# Criar container PostgreSQL
docker run --name lncr-postgres-local \
  -e POSTGRES_DB=lncr_database \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=localpass123 \
  -p 5432:5432 \
  -d postgres:15.12

# Executar scripts SQL manualmente
for sql_file in sql/*.sql; do
  docker exec -i lncr-postgres-local \
    psql -U postgres -d lncr_database < "$sql_file"
done
```

#### Opção 2: Terraform com PostgreSQL Local
```bash
# Modificar provider.tf para usar localhost
# Executar Terraform normalmente
terraform init
terraform plan -var-file="prd.tfvars"
terraform apply -var-file="prd.tfvars"
```

### **Produção AWS**

#### 1. **Preparação do Ambiente**
```bash
# Configurar credenciais AWS
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set default.region us-east-1

# Verificar credenciais
aws sts get-caller-identity
```

#### 2. **Validação de Pré-requisitos**
```bash
# Verificar VPC
aws ec2 describe-vpcs --filters "Name=cidr,Values=10.1.0.0/16"

# Verificar DB Subnet Group
aws rds describe-db-subnet-groups \
  --db-subnet-group-name lncr-prd-data-subnet-group
```

#### 3. **Execução do Terraform**
```bash
# Inicializar Terraform
terraform init

# Validar configuração
terraform validate

# Planejar mudanças
terraform plan -var-file="prd.tfvars" -out=tfplan

# Revisar plano detalhadamente
terraform show tfplan

# Aplicar infraestrutura
terraform apply tfplan
```

#### 4. **Verificação Pós-Deploy**
```bash
# Verificar RDS
aws rds describe-db-instances \
  --db-instance-identifier lncr-prd-postgresql

# Verificar Secret
aws secretsmanager list-secrets \
  --filters Key=name,Values=rds-db-credentials

# Testar conectividade
ENDPOINT=$(terraform output -raw db_instance_endpoint)
SECRET_ARN=$(terraform output -raw master_user_secret_arn)
PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id $SECRET_ARN \
  --query SecretString --output text | jq -r .password)

psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database \
  -c "SELECT version();"
```

---

## 🔄 Pipeline CI/CD

### **GitHub Actions Workflow**

O projeto inclui um pipeline completo de CI/CD com as seguintes etapas:

#### **1. Plan Stage**
- Checkout do código
- Setup do Terraform 1.5.7
- Instalação do PostgreSQL Client
- Validação da configuração
- Geração do plano de execução
- Upload do artefato do plano

#### **2. Approval Stage**
- Aprovação manual obrigatória
- Aprovadores: `gustavo-log`, `titoparizotto`
- Mínimo de 1 aprovação necessária
- Issue automático no GitHub para aprovação

#### **3. Deploy Stage**
- Download do plano aprovado
- Execução do Terraform Apply
- Verificação da estrutura do banco
- Validação pós-deploy

#### **Triggers do Pipeline:**
- `repository_dispatch` com type `infra-base-completed`
- `workflow_dispatch` (execução manual)
- `workflow_call` (chamada de outros workflows)

### **Configuração do Runner**
```yaml
runs-on: codebuild-github-lncr-database-${{ github.run_id }}-${{ github.run_attempt }}
```

---

## 📊 Outputs e Monitoramento

### **Outputs do Terraform**
```hcl
# Endpoint de conexão
output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds_postgresql.db_instance_endpoint
}

# ID da instância
output "db_instance_id" {
  description = "RDS instance ID"
  value       = module.rds_postgresql.db_instance_id
}

# ARN da instância
output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = module.rds_postgresql.db_instance_arn
}

# Security Group ID
output "security_group_id" {
  description = "Security group ID"
  value       = module.rds_postgresql.security_group_id
}

# ARN do Secret
output "master_user_secret_arn" {
  description = "Master user secret ARN"
  value       = module.rds_postgresql.master_user_secret_arn
}
```

### **Métricas de Monitoramento**

#### CloudWatch Metrics Automáticas:
- **DatabaseConnections:** Número de conexões ativas
- **CPUUtilization:** Utilização de CPU da instância
- **FreeableMemory:** Memória disponível
- **ReadLatency/WriteLatency:** Latência de operações
- **DatabaseSize:** Tamanho do banco de dados

#### Alertas Recomendados:
```bash
# CPU > 80% por 5 minutos
aws cloudwatch put-metric-alarm \
  --alarm-name "LNCR-RDS-HighCPU" \
  --alarm-description "RDS CPU utilization is high" \
  --metric-name CPUUtilization \
  --namespace AWS/RDS \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold

# Conexões > 80% do limite
aws cloudwatch put-metric-alarm \
  --alarm-name "LNCR-RDS-HighConnections" \
  --alarm-description "RDS connection count is high" \
  --metric-name DatabaseConnections \
  --namespace AWS/RDS \
  --statistic Average \
  --period 300 \
  --threshold 16 \
  --comparison-operator GreaterThanThreshold
```

---

## 🔐 Segurança e Compliance

### **Controles de Segurança Implementados**

#### 1. **Network Security**
- Security Group restritivo (apenas VPC interna)
- Subnet Group em subnets privadas
- Sem acesso direto da internet

#### 2. **Credential Management**
- AWS Secrets Manager para senhas
- Rotação automática configurável
- Criptografia em repouso (AES-256)
- Criptografia em trânsito (SSL/TLS)

#### 3. **Access Control**
- IAM roles com princípio do menor privilégio
- Auditoria via CloudTrail
- Logs de acesso ao banco

#### 4. **Data Protection**
- Backup automático (7 dias de retenção padrão)
- Point-in-time recovery
- Criptografia de storage

### **Compliance Checklist**
- [ ] Senhas não armazenadas em código
- [ ] Comunicação criptografada
- [ ] Backups automáticos habilitados
- [ ] Logs de auditoria configurados
- [ ] Acesso restrito por rede
- [ ] Princípio do menor privilégio aplicado

---

## 🔗 Conexão ao Banco de Dados

### **Obtenção de Credenciais**
```bash
# Obter ARN do secret
SECRET_ARN=$(terraform output -raw master_user_secret_arn)

# Obter senha
PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id $SECRET_ARN \
  --query SecretString --output text | jq -r .password)

# Obter endpoint
ENDPOINT=$(terraform output -raw db_instance_endpoint)
```

### **Conexão via psql**
```bash
# Conexão direta
psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database

# Com senha inline (não recomendado para produção)
PGPASSWORD=$PASSWORD psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database
```

### **String de Conexão para Aplicações**
```bash
# Formato padrão
postgresql://postgres:$PASSWORD@$ENDPOINT:5432/lncr_database

# Com SSL (recomendado)
postgresql://postgres:$PASSWORD@$ENDPOINT:5432/lncr_database?sslmode=require
```

### **Exemplo de Conexão em Python**
```python
import psycopg2
import boto3
import json

def get_db_connection():
    # Obter credenciais do Secrets Manager
    client = boto3.client('secretsmanager')
    secret_arn = 'arn:aws:secretsmanager:...'  # Do output do Terraform
    
    response = client.get_secret_value(SecretId=secret_arn)
    secret = json.loads(response['SecretString'])
    
    # Conectar ao banco
    conn = psycopg2.connect(
        host='lncr-prd-postgresql.xxxxx.us-east-1.rds.amazonaws.com',
        port=5432,
        database='lncr_database',
        user=secret['username'],
        password=secret['password'],
        sslmode='require'
    )
    
    return conn
```

---

## 🧪 Testes e Validação

### **Testes de Conectividade**
```bash
# Teste básico de conexão
pg_isready -h $ENDPOINT -p 5432

# Teste de autenticação
PGPASSWORD=$PASSWORD psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database -c "SELECT 1;"

# Teste de performance básica
PGPASSWORD=$PASSWORD psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database -c "\timing on; SELECT COUNT(*) FROM customer;"
```

### **Validação do Schema**
```sql
-- Verificar tabelas criadas
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;

-- Verificar constraints
SELECT conname, contype, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE connamespace = 'public'::regnamespace;

-- Verificar índices
SELECT schemaname, tablename, indexname, indexdef 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;

-- Verificar sequences
SELECT sequence_name, data_type, start_value, increment_by 
FROM information_schema.sequences 
WHERE sequence_schema = 'public';
```

### **Testes de Performance**
```sql
-- Teste de inserção
INSERT INTO customer (id, name, email, document_number) 
VALUES (1, 'Test Customer', 'test@example.com', '12345678901');

-- Teste de consulta com join
SELECT c.name, co.id as order_id, co.total_cost
FROM customer c
JOIN customer_order co ON c.id = co.customer_id
WHERE c.id = 1;

-- Teste de índices
EXPLAIN ANALYZE SELECT * FROM customer WHERE email = 'test@example.com';
```

---

## 🛠️ Troubleshooting

### **Problemas Comuns e Soluções**

#### **1. Erro: "DB subnet group not found"**
```bash
# Verificar se o subnet group existe
aws rds describe-db-subnet-groups --db-subnet-group-name lncr-prd-data-subnet-group

# Se não existir, criar manualmente ou via Terraform
resource "aws_db_subnet_group" "main" {
  name       = "lncr-prd-data-subnet-group"
  subnet_ids = [data.aws_subnet.private_a.id, data.aws_subnet.private_b.id]
  
  tags = {
    Name = "LNCR Production DB Subnet Group"
  }
}
```

#### **2. Erro: "VPC not found"**
```bash
# Verificar VPC
aws ec2 describe-vpcs --filters "Name=cidr,Values=10.1.0.0/16"

# Ajustar data source no data.tf se necessário
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["lncr-prd-vpc"]  # Ajustar conforme necessário
  }
}
```

#### **3. Erro: "Security group rules conflict"**
```bash
# Limpar regras conflitantes
aws ec2 describe-security-groups --group-names lncr-prd-rds-sg

# Deletar security group se necessário
aws ec2 delete-security-group --group-id sg-xxxxxxxxx
```

#### **4. Erro: "PostgreSQL connection timeout"**
```bash
# Verificar security group
aws ec2 describe-security-groups --group-ids $(terraform output -raw security_group_id)

# Verificar conectividade de rede
telnet $ENDPOINT 5432

# Verificar status da instância
aws rds describe-db-instances --db-instance-identifier lncr-prd-postgresql
```

#### **5. Scripts SQL falhando**
```bash
# Verificar sintaxe dos arquivos SQL
for file in sql/*.sql; do
  echo "Checking $file..."
  psql -h localhost -U postgres -d test_db --dry-run -f "$file"
done

# Executar scripts manualmente para debug
PGPASSWORD=$PASSWORD psql -h $ENDPOINT -p 5432 -U postgres -d lncr_database -f sql/2-tables.sql -v ON_ERROR_STOP=1
```

### **Logs e Debugging**

#### **Terraform Debug**
```bash
# Habilitar logs detalhados
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Executar com logs
terraform apply -var-file="prd.tfvars"
```

#### **RDS Logs**
```bash
# Listar arquivos de log
aws rds describe-db-log-files --db-instance-identifier lncr-prd-postgresql

# Baixar logs
aws rds download-db-log-file-portion \
  --db-instance-identifier lncr-prd-postgresql \
  --log-file-name error/postgresql.log.2024-01-01-12
```

#### **CloudWatch Logs**
```bash
# Verificar logs do RDS no CloudWatch
aws logs describe-log-groups --log-group-name-prefix /aws/rds/instance/lncr-prd-postgresql

# Visualizar logs recentes
aws logs tail /aws/rds/instance/lncr-prd-postgresql/postgresql --follow
```

---

## 🧹 Limpeza e Manutenção

### **Destruição da Infraestrutura**
```bash
# Backup antes da destruição (recomendado)
aws rds create-db-snapshot \
  --db-instance-identifier lncr-prd-postgresql \
  --db-snapshot-identifier lncr-prd-postgresql-final-snapshot-$(date +%Y%m%d)

# Destruir recursos
terraform destroy -var-file="prd.tfvars"

# Verificar limpeza completa
aws rds describe-db-instances --db-instance-identifier lncr-prd-postgresql
aws secretsmanager list-secrets --filters Key=name,Values=rds-db-credentials
```

### **Manutenção Preventiva**

#### **Backup Manual**
```bash
# Criar snapshot manual
aws rds create-db-snapshot \
  --db-instance-identifier lncr-prd-postgresql \
  --db-snapshot-identifier lncr-prd-postgresql-manual-$(date +%Y%m%d-%H%M)

# Listar snapshots
aws rds describe-db-snapshots --db-instance-identifier lncr-prd-postgresql
```

#### **Monitoramento de Espaço**
```sql
-- Verificar tamanho do banco
SELECT 
    pg_database.datname,
    pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM pg_database
WHERE pg_database.datname = 'lncr_database';

-- Verificar tamanho das tabelas
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

#### **Otimização de Performance**
```sql
-- Analisar estatísticas das tabelas
ANALYZE;

-- Verificar queries lentas (se log_statement = 'all')
SELECT query, mean_time, calls, total_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- Reindexar se necessário
REINDEX DATABASE lncr_database;
```

## 💰 Custos

### Estimativa Mensal (us-east-1)

| Recurso | Tipo | Quantidade | Custo Estimado |
|---------|------|------------|----------------|
| RDS PostgreSQL | db.t4g.small | 1 | $25.00 |
| EBS Storage | gp3 20GB | 1 | $2.40 |
| Secrets Manager | Secret | 1 | $0.40 |
| Data Transfer | Inbound/Outbound | - | $5.00 |
| **Total Estimado** | | | **~$32.80/mês** |

### Otimização de Custos
- Use Reserved Instances para cargas estáveis (até 60% de economia)
- Configure backup retention adequado (7-14 dias)
- Monitore uso de storage e ajuste conforme necessário
- Use Multi-AZ apenas em produção
- Configure auto-scaling de storage

---

## 📚 Referências e Documentação

### **Documentação Oficial**
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon RDS User Guide](https://docs.aws.amazon.com/rds/latest/userguide/)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)
- [PostgreSQL 15 Documentation](https://www.postgresql.org/docs/15/)

### **Best Practices**
- [AWS RDS Best Practices](https://docs.aws.amazon.com/rds/latest/userguide/CHAP_BestPractices.html)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)

### **Ferramentas Complementares**
- [pgAdmin](https://www.pgadmin.org/) - Interface gráfica para PostgreSQL
- [DBeaver](https://dbeaver.io/) - Cliente universal de banco de dados
- [AWS CLI](https://aws.amazon.com/cli/) - Interface de linha de comando da AWS
- [Terraform Cloud](https://cloud.hashicorp.com/products/terraform) - Gerenciamento de estado remoto

## 🤝 Contribuição

### Como Contribuir

1. **Fork** o repositório
2. **Clone** seu fork
3. **Crie** uma branch para sua feature
4. **Faça** suas alterações
5. **Teste** localmente
6. **Commit** com mensagens descritivas
7. **Push** para sua branch
8. **Abra** um Pull Request

### Padrões de Código

#### Terraform
```hcl
# Use nomes descritivos
resource "aws_db_instance" "postgresql" {
  identifier = "${var.prefix_name}-${var.environment}-postgresql"
  # ...
}

# Sempre use tags
tags = {
  Name        = "resource-name"
  Environment = var.environment
  Owner       = "FIAP"
  Project     = "LNCR"
}
```

#### Commits
```
feat: add RDS PostgreSQL module
fix: correct security group rules
docs: update README with examples
refactor: simplify module structure
```

### Testes Antes do PR
```bash
# Validação
terraform fmt -recursive
terraform validate

# Segurança
tfsec .

# Documentação
terraform-docs markdown table --output-file README.md .
```

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👥 Equipe

- **FIAP - 11SOAT** - Turma de Pós-graduação em Software Architecture
- **Responsáveis**: 
  - **Tito Parizotto** - RM 361184
  - **Gustavo Silva** - RM 361477
- **Projeto**: Lanchonete LNCR
- **Fase**: 3 - Infraestrutura de Banco de Dados
- **Arquitetura**: Cloud-native com PostgreSQL RDS
- **Entregável**: Infraestrutura de banco como código

---

**Nota**: Esta documentação é mantida atualizada com as mudanças na infraestrutura. Para dúvidas ou sugestões, abra uma issue no repositório.