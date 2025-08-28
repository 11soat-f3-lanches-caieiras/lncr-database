--
-- PostgreSQL Constraints
-- Definição de todas as constraints (PK, FK, UNIQUE)
--

-- PRIMARY KEY CONSTRAINTS
--
-- Name: customer customer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pk PRIMARY KEY (id);

--
-- Name: customer_order customer_order_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_order_pk PRIMARY KEY (id);

--
-- Name: customer_order_food_item customer_order_food_item_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.customer_order_food_item
    ADD CONSTRAINT customer_order_food_item_pk PRIMARY KEY (id);

--
-- Name: food_item food_item_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.food_item
    ADD CONSTRAINT food_item_pk PRIMARY KEY (id);

--
-- Name: food_item_image food_item_image_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.food_item_image
    ADD CONSTRAINT food_item_image_pk PRIMARY KEY (id);

--
-- Name: kitchen_order kitchen_order_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.kitchen_order
    ADD CONSTRAINT kitchen_order_pk PRIMARY KEY (id);

--
-- Name: kitchen_order_food_item kitchen_order_food_item_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.kitchen_order_food_item
    ADD CONSTRAINT kitchen_order_food_item_pk PRIMARY KEY (id);

--
-- Name: notifications notifications_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pk PRIMARY KEY (id);

--
-- Name: payment payment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pk PRIMARY KEY (id);

--
-- Name: payment_mercadopago payment_mercadopago_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.payment_mercadopago
    ADD CONSTRAINT payment_mercadopago_pk PRIMARY KEY (id);

-- UNIQUE CONSTRAINTS
--
-- Name: customer customer_document_number_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_document_number_uk UNIQUE (document_number);

--
-- Name: customer customer_email_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_uk UNIQUE (email);

--
-- Name: food_item food_item_name_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.food_item
    ADD CONSTRAINT food_item_name_uk UNIQUE (name);

--
-- Name: kitchen_order kichen_order_customer_order_id_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.kitchen_order
    ADD CONSTRAINT kichen_order_customer_order_id_uk UNIQUE (customer_order_id);

--
-- Name: payment payment_order_id_uk; Type: CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_order_id_uk UNIQUE (order_id);

-- FOREIGN KEY CONSTRAINTS
--
-- Name: payment_mercadopago payment_id_meli_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--
ALTER TABLE ONLY public.payment_mercadopago
    ADD CONSTRAINT payment_id_meli_fk FOREIGN KEY (id) REFERENCES public.payment(id);
