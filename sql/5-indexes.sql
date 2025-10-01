--
-- PostgreSQL Indexes
-- Definição de todos os índices para otimização de performance
--

-- Índices para customer
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_document') THEN
        CREATE INDEX idx_customer_document ON public.customer USING btree (document_number);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_email') THEN
        CREATE INDEX idx_customer_email ON public.customer USING btree (email);
    END IF;
END $$;

-- Índices para customer_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_order_customer_id') THEN
        CREATE INDEX idx_customer_order_customer_id ON public.customer_order USING btree (customer_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_order_status_id') THEN
        CREATE INDEX idx_customer_order_status_id ON public.customer_order USING btree (status_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_order_created') THEN
        CREATE INDEX idx_customer_order_created ON public.customer_order USING btree (created);
    END IF;
END $$;

-- Índices para customer_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_order_food_item_order_id') THEN
        CREATE INDEX idx_customer_order_food_item_order_id ON public.customer_order_food_item USING btree (order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_customer_order_food_item_food_item_id') THEN
        CREATE INDEX idx_customer_order_food_item_food_item_id ON public.customer_order_food_item USING btree (food_item_id);
    END IF;
END $$;

-- Índices para food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_food_item_category_id') THEN
        CREATE INDEX idx_food_item_category_id ON public.food_item USING btree (category_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_food_item_name') THEN
        CREATE INDEX idx_food_item_name ON public.food_item USING btree (name);
    END IF;
END $$;

-- Índices para food_item_image
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_food_item_image_food_item_id') THEN
        CREATE INDEX idx_food_item_image_food_item_id ON public.food_item_image USING btree (food_item_id);
    END IF;
END $$;

-- Índices para kitchen_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_kitchen_order_order_id') THEN
        CREATE INDEX idx_kitchen_order_order_id ON public.kitchen_order USING btree (order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_kitchen_order_status') THEN
        CREATE INDEX idx_kitchen_order_status ON public.kitchen_order USING btree (status);
    END IF;
END $$;

-- Índices para kitchen_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_kitchen_order_food_item_kitchen_order_id') THEN
        CREATE INDEX idx_kitchen_order_food_item_kitchen_order_id ON public.kitchen_order_food_item USING btree (kitchen_order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_kitchen_order_food_item_food_item_id') THEN
        CREATE INDEX idx_kitchen_order_food_item_food_item_id ON public.kitchen_order_food_item USING btree (food_item_id);
    END IF;
END $$;

-- Índices para notifications
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_notifications_order_id') THEN
        CREATE INDEX idx_notifications_order_id ON public.notifications USING btree (order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_notifications_created') THEN
        CREATE INDEX idx_notifications_created ON public.notifications USING btree (created);
    END IF;
END $$;

-- Índices para payment
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_payment_order_id') THEN
        CREATE INDEX idx_payment_order_id ON public.payment USING btree (order_id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_payment_status') THEN
        CREATE INDEX idx_payment_status ON public.payment USING btree (status);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_payment_created') THEN
        CREATE INDEX idx_payment_created ON public.payment USING btree (created);
    END IF;
END $$;
