--
-- PostgreSQL Indexes
-- Definição de todos os índices para otimização de performance
--

-- Índices para customer
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_id_idx') THEN
        CREATE INDEX customer_id_idx ON public.customer USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_document_number_idx') THEN
        CREATE INDEX customer_document_number_idx ON public.customer USING btree (document_number);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_email_idx') THEN
        CREATE INDEX customer_email_idx ON public.customer USING btree (email);
    END IF;
END $$;

-- Índices para customer_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_id_idx') THEN
        CREATE INDEX customer_order_id_idx ON public.customer_order USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_customer_id_idx') THEN
        CREATE INDEX customer_order_customer_id_idx ON public.customer_order USING btree (customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_status_idx') THEN
        CREATE INDEX customer_order_status_idx ON public.customer_order USING btree (status_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_created_idx') THEN
        CREATE INDEX customer_order_created_idx ON public.customer_order USING btree (created);
    END IF;
END $$;

-- Índices para customer_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_food_item_id_idx') THEN
        CREATE INDEX customer_order_food_item_id_idx ON public.customer_order_food_item USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'customer_order_food_item_order_id_idx') THEN
        CREATE INDEX customer_order_food_item_order_id_idx ON public.customer_order_food_item USING btree (order_id);
    END IF;
END $$;

-- Índices para food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'food_item_id_idx') THEN
        CREATE INDEX food_item_id_idx ON public.food_item USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'food_item_category_idx') THEN
        CREATE INDEX food_item_category_idx ON public.food_item USING btree (category_id);
    END IF;
END $$;

-- Índices para food_item_image
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'food_item_image_id_idx') THEN
        CREATE INDEX food_item_image_id_idx ON public.food_item_image USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'food_item_image_food_item_id_idx') THEN
        CREATE INDEX food_item_image_food_item_id_idx ON public.food_item_image USING btree (food_item_id);
    END IF;
END $$;

-- Índices para kitchen_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_id_idx') THEN
        CREATE INDEX kitchen_order_id_idx ON public.kitchen_order USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_customer_order_id_idx') THEN
        CREATE INDEX kitchen_order_customer_order_id_idx ON public.kitchen_order USING btree (customer_order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_status_id_idx') THEN
        CREATE INDEX kitchen_order_status_id_idx ON public.kitchen_order USING btree (status_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_created_idx') THEN
        CREATE INDEX kitchen_order_created_idx ON public.kitchen_order USING btree (created);
    END IF;
END $$;

-- Índices para kitchen_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_item_id_idx') THEN
        CREATE INDEX kitchen_order_item_id_idx ON public.kitchen_order_food_item USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'kitchen_order_item_kitchen_order_id_idx') THEN
        CREATE INDEX kitchen_order_item_kitchen_order_id_idx ON public.kitchen_order_food_item USING btree (kitchen_order_id);
    END IF;
END $$;

-- Índices para notifications
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'notifications_type_idx') THEN
        CREATE INDEX notifications_type_idx ON public.notifications USING btree (notification_type);
    END IF;
END $$;

-- Índices para payment
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'payment_id_idx') THEN
        CREATE INDEX payment_id_idx ON public.payment USING btree (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'payment_order_id_idx') THEN
        CREATE INDEX payment_order_id_idx ON public.payment USING btree (order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'payment_status_id_idx') THEN
    END IF;
END $$;

-- Índices para payment_mercadopago
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'payment_meli_id_idx') THEN
        CREATE INDEX payment_meli_id_idx ON public.payment_mercadopago USING btree (id);
    END IF;
END $$;
