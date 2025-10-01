--
-- PostgreSQL Constraints
-- Definição de todas as constraints (PK, FK, UNIQUE)
--

-- PRIMARY KEY CONSTRAINTS
--
-- Name: customer customer_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT IF NOT EXISTS customer_pk PRIMARY KEY (id);

--
-- Name: customer_order customer_order_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT IF NOT EXISTS customer_order_pk PRIMARY KEY (id);

--
-- Name: customer_order_food_item customer_order_food_item_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.customer_order_food_item
    ADD CONSTRAINT IF NOT EXISTS customer_order_food_item_pk PRIMARY KEY (id);

--
-- Name: food_item food_item_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.food_item
    ADD CONSTRAINT IF NOT EXISTS food_item_pk PRIMARY KEY (id);

--
-- Name: food_item_image food_item_image_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.food_item_image
    ADD CONSTRAINT IF NOT EXISTS food_item_image_pk PRIMARY KEY (id);

--
-- Name: kitchen_order kitchen_order_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.kitchen_order
    ADD CONSTRAINT IF NOT EXISTS kitchen_order_pk PRIMARY KEY (id);

--
-- Name: kitchen_order_food_item kitchen_order_food_item_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.kitchen_order_food_item
    ADD CONSTRAINT IF NOT EXISTS kitchen_order_food_item_pk PRIMARY KEY (id);

--
-- Name: notifications notifications_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT IF NOT EXISTS notifications_pk PRIMARY KEY (id);

--
-- Name: payment payment_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.payment
    ADD CONSTRAINT IF NOT EXISTS payment_pk PRIMARY KEY (id);

--
-- Name: payment_mercadopago payment_mercadopago_pk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.payment_mercadopago
    ADD CONSTRAINT IF NOT EXISTS payment_mercadopago_pk PRIMARY KEY (id);

-- UNIQUE CONSTRAINTS
--
-- Name: customer customer_document_number_uk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT IF NOT EXISTS customer_document_number_uk UNIQUE (document_number);

--
-- Name: customer customer_email_uk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT IF NOT EXISTS customer_email_uk UNIQUE (email);

--
-- Name: food_item food_item_name_uk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.food_item
    ADD CONSTRAINT IF NOT EXISTS food_item_name_uk UNIQUE (name);

--
-- Name: kitchen_order kichen_order_customer_order_id_uk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.kitchen_order
    ADD CONSTRAINT IF NOT EXISTS kichen_order_customer_order_id_uk UNIQUE (customer_order_id);

--
-- Name: payment payment_order_id_uk; Type: CONSTRAINT; Schema: public
--
ALTER TABLE ONLY public.payment
    ADD CONSTRAINT IF NOT EXISTS payment_order_id_uk UNIQUE (order_id);

-- FOREIGN KEY CONSTRAINTS
--
-- Name: payment_mercadopago payment_id_meli_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'payment_id_meli_fk'
        AND table_name = 'payment_mercadopago'
    ) THEN
        ALTER TABLE ONLY public.payment_mercadopago
            ADD CONSTRAINT payment_id_meli_fk FOREIGN KEY (id) REFERENCES public.payment(id);
    END IF;
END $$;
