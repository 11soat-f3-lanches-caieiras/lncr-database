# Diagrama ER Interativo - LNCR System

## Visualização Online do Banco de Dados

Este é o Diagrama Entidade-Relacionamento (DER) interativo do sistema LNCR, renderizado através do dbdiagram.io.

### Acesso ao Diagrama
**Link direto:** https://dbdiagram.io/e/68e04206d2b621e42234ba71/68e0421bd2b621e42234bcbe

<iframe width="560" height="315" src='https://dbdiagram.io/e/68e04206d2b621e42234ba71/68e0421bd2b621e42234bcbe'> </iframe>

### Como Usar

1. **Navegação:** Use o mouse para fazer zoom e mover o diagrama
2. **Interação:** Clique nas tabelas para ver detalhes dos campos
3. **Relacionamentos:** As linhas conectam as tabelas mostrando as foreign keys
4. **Edição:** Para editar, acesse diretamente [dbdiagram.io](https://dbdiagram.io/e/68e04206d2b621e42234ba71/68e0421bd2b621e42234bcbe)

### Recursos Disponíveis

- **Visualização completa** de todas as 10 tabelas
- **Relacionamentos visuais** entre as entidades
- **Campos detalhados** com tipos e constraints
- **Índices** e **chaves** claramente identificados
- **Enums** para status e categorias
- **Comentários** explicativos em português

### Tabelas Incluídas

1. **customer** - Cadastro de clientes
2. **food_item** - Itens do cardápio
3. **food_item_image** - Imagens dos produtos
4. **customer_order** - Pedidos dos clientes
5. **customer_order_food_item** - Itens dos pedidos
6. **kitchen_order** - Pedidos da cozinha
7. **kitchen_order_food_item** - Itens da cozinha
8. **payment** - Controle de pagamentos
9. **payment_mercadopago** - Extensão MercadoPago
10. **notifications** - Sistema de notificações

### Domínios Arquiteturais

O diagrama mostra claramente a separação em bounded contexts:

- 🔵 **Cliente** - Gestão de usuários
- 🟢 **Cardápio** - Produtos e imagens
- 🟡 **Pedidos** - Carrinho e checkout
- 🟠 **Cozinha** - Preparo e status
- 🔴 **Pagamentos** - Processamento financeiro
- 🟣 **Notificações** - Sistema de alertas

### Exportação

O diagrama pode ser exportado em diversos formatos:
- **PNG/SVG** - Para documentação
- **PDF** - Para impressão
- **SQL** - Scripts de criação
- **DBML** - Código fonte

### Código Fonte

O código DBML completo está disponível no arquivo [`DER_DBML.dbml`](./DER_DBML.dbml) neste mesmo diretório.

---



