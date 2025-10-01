--
-- PostgreSQL Database Configuration
-- Configurações de conexão e ambiente do banco de dados

-- Nota: O banco é criado automaticamente pelo Terraform RDS
-- Este script apenas configura o ambiente e sessão

-- Configurações de timeout e sessão
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;

-- Configurações de encoding e padrões
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);

-- Configurações de validação e comportamento
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Configurações de tablespace e métodos de acesso
SET default_tablespace = '';
SET default_table_access_method = heap;

-- Extensões úteis para o sistema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Comentário no banco atual
COMMENT ON DATABASE CURRENT_DATABASE IS 'Lanches Caieiras - Sistema de Pedidos';
