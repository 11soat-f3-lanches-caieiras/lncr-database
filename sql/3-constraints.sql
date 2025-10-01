--
-- PostgreSQL Constraints
-- Definição de todas as constraints (PK, FK, UNIQUE)
--

-- PRIMARY KEY CONSTRAINTS
--
-- Name: customer customer_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_pk') THEN
        ALTER TABLE ONLY public.customer ADD CONSTRAINT customer_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: customer_order customer_order_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_order_pk') THEN
        ALTER TABLE ONLY public.customer_order ADD CONSTRAINT customer_order_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: customer_order_food_item customer_order_food_item_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_order_food_item_pk') THEN
        ALTER TABLE ONLY public.customer_order_food_item ADD CONSTRAINT customer_order_food_item_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: food_item food_item_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'food_item_pk') THEN
        ALTER TABLE ONLY public.food_item ADD CONSTRAINT food_item_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: food_item_image food_item_image_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'food_item_image_pk') THEN
        ALTER TABLE ONLY public.food_item_image ADD CONSTRAINT food_item_image_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: kitchen_order kitchen_order_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kitchen_order_pk') THEN
        ALTER TABLE ONLY public.kitchen_order ADD CONSTRAINT kitchen_order_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: kitchen_order_food_item kitchen_order_food_item_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kitchen_order_food_item_pk') THEN
        ALTER TABLE ONLY public.kitchen_order_food_item ADD CONSTRAINT kitchen_order_food_item_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: notifications notifications_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'notifications_pk') THEN
        ALTER TABLE ONLY public.notifications ADD CONSTRAINT notifications_pk PRIMARY KEY (id);
    END IF;
END $$;

--
-- Name: payment payment_pk; Type: CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'payment_pk') THEN
        ALTER TABLE ONLY public.payment ADD CONSTRAINT payment_pk PRIMARY KEY (id);
    END IF;
END $$;

-- FOREIGN KEY CONSTRAINTS
--
-- Name: customer_order customer_order_customer_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_order_customer_fk') THEN
        ALTER TABLE ONLY public.customer_order ADD CONSTRAINT customer_order_customer_fk FOREIGN KEY (customer_id) REFERENCES public.customer(id);
    END IF;
END $$;

--
-- Name: customer_order_food_item customer_order_food_item_food_item_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_order_food_item_food_item_fk') THEN
        ALTER TABLE ONLY public.customer_order_food_item ADD CONSTRAINT customer_order_food_item_food_item_fk FOREIGN KEY (food_item_id) REFERENCES public.food_item(id);
    END IF;
END $$;

--
-- Name: customer_order_food_item customer_order_food_item_order_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_order_food_item_order_fk') THEN
        ALTER TABLE ONLY public.customer_order_food_item ADD CONSTRAINT customer_order_food_item_order_fk FOREIGN KEY (order_id) REFERENCES public.customer_order(id);
    END IF;
END $$;

--
-- Name: food_item_image food_item_image_food_item_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'food_item_image_food_item_fk') THEN
        ALTER TABLE ONLY public.food_item_image ADD CONSTRAINT food_item_image_food_item_fk FOREIGN KEY (food_item_id) REFERENCES public.food_item(id);
    END IF;
END $$;

--
-- Name: kitchen_order kitchen_order_order_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kitchen_order_order_fk') THEN
        ALTER TABLE ONLY public.kitchen_order ADD CONSTRAINT kitchen_order_order_fk FOREIGN KEY (customer_order_id) REFERENCES public.customer_order(id);
    END IF;
END $$;

--
-- Name: kitchen_order_food_item kitchen_order_food_item_food_item_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kitchen_order_food_item_food_item_fk') THEN
        ALTER TABLE ONLY public.kitchen_order_food_item ADD CONSTRAINT kitchen_order_food_item_food_item_fk FOREIGN KEY (food_item_id) REFERENCES public.food_item(id);
    END IF;
END $$;

--
-- Name: kitchen_order_food_item kitchen_order_food_item_kitchen_order_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kitchen_order_food_item_kitchen_order_fk') THEN
        ALTER TABLE ONLY public.kitchen_order_food_item ADD CONSTRAINT kitchen_order_food_item_kitchen_order_fk FOREIGN KEY (kitchen_order_id) REFERENCES public.kitchen_order(id);
    END IF;
END $$;

--
-- Name: payment payment_order_fk; Type: FK CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'payment_order_fk') THEN
        ALTER TABLE ONLY public.payment ADD CONSTRAINT payment_order_fk FOREIGN KEY (order_id) REFERENCES public.customer_order(id);
    END IF;
END $$;

-- UNIQUE CONSTRAINTS
--
-- Name: customer customer_document_unique; Type: UNIQUE CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_document_unique') THEN
        ALTER TABLE ONLY public.customer ADD CONSTRAINT customer_document_unique UNIQUE (document_number);
    END IF;
END $$;

--
-- Name: customer customer_email_unique; Type: UNIQUE CONSTRAINT; Schema: public
--
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_email_unique') THEN
        ALTER TABLE ONLY public.customer ADD CONSTRAINT customer_email_unique UNIQUE (email);
    END IF;
END $$;
