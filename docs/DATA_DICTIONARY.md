# Dicionário de Dados - LNCR System

## Informações Gerais
- **Sistema:** LNCR (Lanches Caieiras)
- **SGBD:** PostgreSQL 
- **Schema:** public
- **Versão:** 2.0
- **Data:** 03 de outubro de 2025

---

## Tabelas e Campos Detalhados

### 1. CUSTOMER (Cliente)
**Propósito:** Armazenar informações dos clientes cadastrados na lanchonete.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('customer_id_seq') | PK | customer_id_idx | Identificador único do cliente |
| document_number | VARCHAR(255) | SIM | NULL | UNIQUE | customer_document_number_idx | CPF ou CNPJ do cliente |
| email | VARCHAR(255) | SIM | NULL | UNIQUE | customer_email_idx | Email para contato |
| name | VARCHAR(255) | SIM | NULL | - | - | Nome completo do cliente |

**Regras de Negócio:**
- Cliente pode ser anônimo (campos opcionais)
- document_number deve ser único quando informado
- email deve ser único quando informado

---

### 2. FOOD_ITEM (Item do Cardápio)
**Propósito:** Catálogo de produtos disponíveis para venda.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('food_item_id_seq') | PK | food_item_id_idx | Identificador único do item |
| category_id | INTEGER | SIM | NULL | - | food_item_category_idx | Categoria: 1-Lanche, 2-Acompanhamento, 3-Bebida, 4-Sobremesa |
| description | VARCHAR(255) | SIM | NULL | - | - | Descrição detalhada do produto |
| name | VARCHAR(255) | SIM | NULL | UNIQUE | - | Nome único do produto |
| price | DOUBLE PRECISION | SIM | NULL | - | - | Preço unitário em reais |

**Regras de Negócio:**
- Nome deve ser único
- Preço sempre positivo
- Categoria define a organização no cardápio

---

### 3. FOOD_ITEM_IMAGE (Imagens dos Produtos)
**Propósito:** Armazenar referências às imagens dos produtos do cardápio.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('food_item_image_id_seq') | PK | food_item_image_id_idx | Identificador único da imagem |
| file_name | VARCHAR(255) | SIM | NULL | - | - | Nome do arquivo de imagem |
| food_item_id | INTEGER | SIM | NULL | FK → food_item.id | food_item_image_food_item_id_idx | Referência ao produto |

**Regras de Negócio:**
- Um produto pode ter múltiplas imagens
- file_name deve referenciar arquivo válido no storage
- Exclusão em cascata quando produto é removido

---

### 4. CUSTOMER_ORDER (Pedido)
**Propósito:** Registrar pedidos realizados pelos clientes.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('customer_order_id_seq') | PK | customer_order_id_idx | Identificador único do pedido |
| created | TIMESTAMP | SIM | NULL | - | customer_order_created_idx | Data/hora de criação |
| customer_id | INTEGER | SIM | NULL | - | customer_order_customer_id_idx | Referência ao cliente (opcional) |
| status_id | INTEGER | SIM | NULL | - | customer_order_status_idx | Status atual do pedido |
| total_cost | DOUBLE PRECISION | SIM | NULL | - | - | Valor total calculado |
| updated | TIMESTAMP | SIM | NULL | - | - | Última atualização |

**Status Possíveis:**
- 1: Criado
- 2: Confirmado  
- 3: Em Preparo
- 4: Pronto
- 5: Entregue
- 6: Cancelado

**Regras de Negócio:**
- customer_id pode ser NULL (pedido anônimo)
- total_cost calculado automaticamente
- Timestamps para auditoria

---

### 5. CUSTOMER_ORDER_FOOD_ITEM (Itens do Pedido)
**Propósito:** Relacionar produtos aos pedidos com quantidades e observações.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('customer_order_food_item_id_seq') | PK | customer_order_food_item_id_idx | Identificador único |
| food_item_id | INTEGER | SIM | NULL | - | - | Referência ao produto do cardápio |
| notes | VARCHAR(255) | SIM | NULL | - | - | Observações especiais |
| order_id | INTEGER | SIM | NULL | FK → customer_order.id | customer_order_food_item_order_id_idx | Referência ao pedido |
| price | DOUBLE PRECISION | SIM | NULL | - | - | Preço histórico do item |

**Regras de Negócio:**
- price registra valor no momento do pedido (histórico)
- notes para customizações ("sem cebola", "ponto da carne")
- food_item_id referência "fraca" para manter histórico

---

### 6. KITCHEN_ORDER (Pedido da Cozinha)
**Propósito:** Representar pedidos no contexto da cozinha.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('kitchen_order_id_seq') | PK | - | Identificador único |
| created | TIMESTAMP | SIM | NULL | - | - | Quando chegou na cozinha |
| customer_order_id | INTEGER | SIM | NULL | UNIQUE | - | Referência única ao pedido original |
| status_id | INTEGER | SIM | NULL | - | - | Status na cozinha |
| updated | TIMESTAMP | SIM | NULL | - | - | Última atualização |

**Status da Cozinha:**
- 1: Recebido
- 2: Em Preparo  
- 3: Pronto
- 4: Entregue

**Regras de Negócio:**
- Relacionamento 1:1 com customer_order
- Criado automaticamente quando pedido é confirmado
- Contexto isolado da cozinha

---

### 7. KITCHEN_ORDER_FOOD_ITEM (Itens do Pedido na Cozinha)
**Propósito:** Itens específicos para preparo na cozinha.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('kitchen_order_food_item_id_seq') | PK | - | Identificador único |
| description | VARCHAR(255) | SIM | NULL | - | - | Descrição para a cozinha |
| kitchen_order_id | INTEGER | SIM | NULL | FK → kitchen_order.id | - | Referência ao pedido da cozinha |
| name | VARCHAR(255) | SIM | NULL | - | - | Nome do item |
| notes | VARCHAR(255) | SIM | NULL | - | - | Instruções de preparo |

**Regras de Negócio:**
- Dados copiados/simplificados do pedido original
- Foco nas informações necessárias para preparo
- Sem referência direta ao cardápio (snapshot)

---

### 8. PAYMENT (Pagamento)
**Propósito:** Controlar pagamentos dos pedidos.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('payment_id_seq') | PK | - | Identificador único |
| amount | DOUBLE PRECISION | SIM | NULL | - | - | Valor do pagamento |
| created | TIMESTAMP | SIM | NULL | - | - | Data/hora de criação |
| external_payment_id | VARCHAR(255) | SIM | NULL | - | - | ID do provedor externo |
| order_id | INTEGER | SIM | NULL | UNIQUE | - | Referência única ao pedido |
| payment_method | VARCHAR(255) | SIM | NULL | - | - | PIX, cartão, dinheiro |
| payment_provider | VARCHAR(255) | SIM | NULL | - | - | MercadoPago, PagSeguro, etc. |
| status_id | INTEGER | SIM | NULL | - | - | Status do pagamento |
| updated | TIMESTAMP | SIM | NULL | - | - | Última atualização |

**Status de Pagamento:**
- 1: Pendente
- 2: Processando
- 3: Aprovado
- 4: Rejeitado
- 5: Cancelado

**Regras de Negócio:**
- Relacionamento 1:1 com pedido
- Suporte a múltiplos provedores
- Rastreamento completo do ciclo

---

### 9. PAYMENT_MERCADOPAGO (Pagamento MercadoPago)
**Propósito:** Extensão específica para pagamentos via MercadoPago.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | - | PK, FK → payment.id | - | Herança do pagamento base |
| meli_id | VARCHAR(255) | SIM | NULL | - | - | ID específico do MercadoLibre |
| qr_data | VARCHAR(255) | SIM | NULL | - | - | Dados para geração QR Code PIX |

**Regras de Negócio:**
- Padrão de herança (Table per Type)
- Campos específicos do provedor
- Extensível para outros provedores

---

### 10. NOTIFICATIONS (Notificações)
**Propósito:** Sistema de notificações do aplicativo.

| Campo | Tipo | Nulo | Default | Constraints | Índices | Descrição |
|-------|------|------|---------|-------------|---------|-----------|
| id | INTEGER | NÃO | nextval('notifications_id_seq') | PK | - | Identificador único |
| artefact_id | INTEGER | SIM | NULL | - | - | ID do objeto relacionado |
| created | TIMESTAMP | SIM | NULL | - | - | Data/hora da notificação |
| message | VARCHAR(255) | SIM | NULL | - | - | Mensagem da notificação |
| notification_type | VARCHAR(255) | SIM | NULL | - | - | Tipo da notificação |

**Tipos de Notificação:**
- order_status: Mudança status pedido
- payment_status: Mudança status pagamento  
- kitchen_update: Atualizações da cozinha
- system_alert: Alertas do sistema

**Regras de Negócio:**
- artefact_id referencia ID do objeto relacionado
- Suporte a diferentes tipos de evento
- Histórico completo de notificações

---

## Sequências Auto-incremento

Todas as tabelas principais utilizam sequências PostgreSQL:

| Tabela | Sequência | Início | Incremento |
|--------|-----------|---------|------------|
| customer | customer_id_seq | 1 | 1 |
| customer_order | customer_order_id_seq | 1 | 1 |
| customer_order_food_item | customer_order_food_item_id_seq | 1 | 1 |
| food_item | food_item_id_seq | 1 | 1 |
| food_item_image | food_item_image_id_seq | 1 | 1 |
| kitchen_order | kitchen_order_id_seq | 1 | 1 |
| kitchen_order_food_item | kitchen_order_food_item_id_seq | 1 | 1 |
| notifications | notifications_id_seq | 1 | 1 |
| payment | payment_id_seq | 1 | 1 |

---

## Políticas de Backup e Manutenção

### Backup
- Backup completo diário
- Log de transações contínuo
- Retenção: 30 dias para backups completos

### Manutenção
- VACUUM ANALYZE semanal
- Reindex mensal em tabelas críticas
- Monitoramento de crescimento das sequências

### Auditoria
- Campos created/updated em tabelas principais
- Log de alterações via triggers (quando necessário)
- Retenção de dados históricos por 2 anos
