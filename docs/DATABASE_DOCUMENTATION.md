# Documentação do Banco de Dados - LNCR System

## Visão Geral
Sistema de gerenciamento de pedidos para lanchonete, com controle de clientes, cardápio, pedidos, cozinha e pagamentos.

**SGBD:** PostgreSQL  
**Schema:** public  
**Data de Criação:** 03 de outubro de 2025  

---

## Diagrama Entidade-Relacionamento (DER)

### Entidades Principais

#### 1. **CUSTOMER** (Cliente)
Armazena informações dos clientes da lanchonete.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único do cliente |
| document_number | VARCHAR(255) | UNIQUE, INDEX | CPF/CNPJ do cliente |
| email | VARCHAR(255) | UNIQUE, INDEX | Email do cliente |
| name | VARCHAR(255) | | Nome do cliente |

**Índices:**
- `customer_id_idx` (BTREE)
- `customer_document_number_idx` (BTREE)
- `customer_email_idx` (BTREE)

---

#### 2. **FOOD_ITEM** (Item do Cardápio)
Catálogo de produtos disponíveis na lanchonete.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único do item |
| category_id | INTEGER | INDEX | Categoria do item (lanche, bebida, etc.) |
| description | VARCHAR(255) | | Descrição detalhada do item |
| name | VARCHAR(255) | UNIQUE | Nome do item |
| price | DOUBLE PRECISION | | Preço unitário |

**Índices:**
- `food_item_id_idx` (BTREE)
- `food_item_category_idx` (BTREE)

---

#### 3. **FOOD_ITEM_IMAGE** (Imagens dos Itens)
Armazena referências às imagens dos itens do cardápio.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único da imagem |
| file_name | VARCHAR(255) | | Nome do arquivo da imagem |
| food_item_id | INTEGER | FK → food_item.id, INDEX | Referência ao item |

**Relacionamentos:**
- N:1 com FOOD_ITEM

---

#### 4. **CUSTOMER_ORDER** (Pedido do Cliente)
Pedidos realizados pelos clientes.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único do pedido |
| created | TIMESTAMP | INDEX | Data/hora de criação |
| customer_id | INTEGER | INDEX | Referência ao cliente (opcional) |
| status_id | INTEGER | INDEX | Status do pedido |
| total_cost | DOUBLE PRECISION | | Valor total do pedido |
| updated | TIMESTAMP | | Data/hora da última atualização |

**Índices:**
- `customer_order_id_idx` (BTREE)
- `customer_order_customer_id_idx` (BTREE)
- `customer_order_status_idx` (BTREE)
- `customer_order_created_idx` (BTREE)

---

#### 5. **CUSTOMER_ORDER_FOOD_ITEM** (Itens do Pedido)
Relaciona itens do cardápio aos pedidos (carrinho de compras).

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único |
| food_item_id | INTEGER | | Referência ao item do cardápio |
| notes | VARCHAR(255) | | Observações especiais |
| order_id | INTEGER | FK → customer_order.id, INDEX | Referência ao pedido |
| price | DOUBLE PRECISION | | Preço no momento do pedido |

**Relacionamentos:**
- N:1 com CUSTOMER_ORDER
- N:1 com FOOD_ITEM (referência sem FK)

---

#### 6. **KITCHEN_ORDER** (Pedido da Cozinha)
Representa os pedidos enviados para a cozinha.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único |
| created | TIMESTAMP | | Data/hora de criação |
| customer_order_id | INTEGER | UNIQUE | Referência única ao pedido |
| status_id | INTEGER | | Status na cozinha |
| updated | TIMESTAMP | | Última atualização |

**Relacionamentos:**
- 1:1 com CUSTOMER_ORDER (referência sem FK)

---

#### 7. **KITCHEN_ORDER_FOOD_ITEM** (Itens do Pedido da Cozinha)
Itens específicos do pedido na cozinha.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único |
| description | VARCHAR(255) | | Descrição do item |
| kitchen_order_id | INTEGER | FK → kitchen_order.id | Referência ao pedido da cozinha |
| name | VARCHAR(255) | | Nome do item |
| notes | VARCHAR(255) | | Observações especiais |

**Relacionamentos:**
- N:1 com KITCHEN_ORDER

---

#### 8. **PAYMENT** (Pagamento)
Controla os pagamentos dos pedidos.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único |
| amount | DOUBLE PRECISION | | Valor do pagamento |
| created | TIMESTAMP | | Data/hora de criação |
| external_payment_id | VARCHAR(255) | | ID do pagamento externo |
| order_id | INTEGER | UNIQUE | Referência única ao pedido |
| payment_method | VARCHAR(255) | | Método de pagamento |
| payment_provider | VARCHAR(255) | | Provedor de pagamento |
| status_id | INTEGER | | Status do pagamento |
| updated | TIMESTAMP | | Última atualização |

**Relacionamentos:**
- 1:1 com CUSTOMER_ORDER (referência sem FK)

---

#### 9. **PAYMENT_MERCADOPAGO** (Pagamento MercadoPago)
Extensão específica para pagamentos via MercadoPago.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, FK → payment.id | Referência ao pagamento |
| meli_id | VARCHAR(255) | | ID do MercadoLibre |
| qr_data | VARCHAR(255) | | Dados do QR Code |

**Relacionamentos:**
- 1:1 com PAYMENT (herança)

---

#### 10. **NOTIFICATIONS** (Notificações)
Sistema de notificações do aplicativo.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| id | INTEGER | PK, AUTO_INCREMENT | Identificador único |
| artefact_id | INTEGER | | ID do artefato relacionado |
| created | TIMESTAMP | | Data/hora de criação |
| message | VARCHAR(255) | | Mensagem da notificação |
| notification_type | VARCHAR(255) | | Tipo de notificação |

---

## Relacionamentos Principais

```
CUSTOMER ||--o{ CUSTOMER_ORDER : "faz pedidos"
CUSTOMER_ORDER ||--|| KITCHEN_ORDER : "gera pedido na cozinha"
CUSTOMER_ORDER ||--|| PAYMENT : "possui pagamento"
CUSTOMER_ORDER ||--o{ CUSTOMER_ORDER_FOOD_ITEM : "contém itens"
FOOD_ITEM ||--o{ FOOD_ITEM_IMAGE : "possui imagens"
KITCHEN_ORDER ||--o{ KITCHEN_ORDER_FOOD_ITEM : "contém itens"
PAYMENT ||--|| PAYMENT_MERCADOPAGO : "pagamento específico"
```

---

## Arquitetura e Decisões de Design

### Padrões Utilizados
1. **Bounded Context**: Separação entre domínios (pedido, cozinha, pagamento)
2. **Weak References**: FKs apenas dentro do mesmo contexto
3. **Event Sourcing**: Rastreamento de mudanças com timestamps
4. **Extensibility**: Tabelas específicas por provedor de pagamento

### Índices de Performance
- Índices em chaves primárias e estrangeiras
- Índices em campos de busca frequente (email, document_number)
- Índices em campos de filtro (status_id, created)
- Índices compostos para consultas específicas

### Sequências Auto-incremento
Todas as tabelas principais utilizam sequências PostgreSQL para auto-incremento das chaves primárias, garantindo unicidade e performance.

---

## Status e Estados

### Customer Order Status
- Status controlado via `status_id`
- Estados típicos: Criado, Confirmado, Em Preparo, Pronto, Entregue, Cancelado

### Kitchen Order Status  
- Status controlado via `status_id`
- Estados típicos: Recebido, Em Preparo, Pronto, Entregue

### Payment Status
- Status controlado via `status_id` 
- Estados típicos: Pendente, Processando, Aprovado, Rejeitado, Cancelado

---

## Considerações de Segurança

1. **Dados Sensíveis**: CPF/email com constraints UNIQUE
2. **Auditoria**: Campos `created` e `updated` para rastreamento
3. **Integridade**: Constraints de FK onde aplicável
4. **Performance**: Índices otimizados para consultas frequentes

---

## Scripts de Manutenção

Os scripts SQL estão organizados em:
- `1-database-config.sql` - Configurações do banco
- `2-tables.sql` - Criação das tabelas
- `3-constraints.sql` - PKs, FKs e UNIQUEs
- `4-sequences.sql` - Sequências auto-incremento
- `5-indexes.sql` - Índices de performance
