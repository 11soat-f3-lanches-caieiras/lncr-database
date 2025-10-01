--
-- PostgreSQL Indexes
-- Definição de todos os índices do banco de dados
--

--
-- Name: customer_document_number_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_document_number_idx ON public.customer USING btree (document_number) WITH (deduplicate_items='true');

--
-- Name: customer_email_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_email_idx ON public.customer USING btree (email) WITH (deduplicate_items='true');

--
-- Name: customer_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_id_idx ON public.customer USING btree (id) WITH (deduplicate_items='false');

--
-- Name: customer_order_customerid_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_order_customerid_idx ON public.customer_order USING btree (customer_id) WITH (deduplicate_items='true');

--
-- Name: customer_order_food_item_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_order_food_item_id_idx ON public.customer_order_food_item USING btree (id) WITH (deduplicate_items='true');

--
-- Name: customer_order_food_item_order_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_order_food_item_order_id_idx ON public.customer_order_food_item USING btree (order_id) WITH (deduplicate_items='true');

--
-- Name: customer_order_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_order_id_idx ON public.customer_order USING btree (id) WITH (deduplicate_items='true');

--
-- Name: customer_order_status_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS customer_order_status_idx ON public.customer_order USING btree (status_id) WITH (deduplicate_items='true');

--
-- Name: food_item_category_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS food_item_category_idx ON public.food_item USING btree (category_id) WITH (deduplicate_items='true');

--
-- Name: food_item_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS food_item_id_idx ON public.food_item USING btree (id) WITH (deduplicate_items='true');

--
-- Name: food_item_image_food_item_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS food_item_image_food_item_id_idx ON public.food_item_image USING btree (food_item_id) WITH (deduplicate_items='true');

--
-- Name: food_item_image_id; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS food_item_image_id ON public.food_item_image USING btree (id) WITH (deduplicate_items='true');

--
-- Name: kitchen_order_id_customer_order_id; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS kitchen_order_id_customer_order_id ON public.kitchen_order USING btree (customer_order_id) WITH (deduplicate_items='true');

--
-- Name: kitchen_order_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS kitchen_order_id_idx ON public.kitchen_order USING btree (id) WITH (deduplicate_items='true');

--
-- Name: kitchen_order_id_status_id; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS kitchen_order_id_status_id ON public.kitchen_order USING btree (status_id) WITH (deduplicate_items='true');

--
-- Name: kitchen_order_item_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS kitchen_order_item_id_idx ON public.kitchen_order_food_item USING btree (id) WITH (deduplicate_items='false');

--
-- Name: kitchen_order_item_kitchen_order_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS kitchen_order_item_kitchen_order_id_idx ON public.kitchen_order_food_item USING btree (kitchen_order_id) WITH (deduplicate_items='false');

--
-- Name: notifications_type_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS notifications_type_idx ON public.notifications USING btree (notification_type) WITH (deduplicate_items='false');

--
-- Name: payment_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS payment_id_idx ON public.payment USING btree (id) WITH (deduplicate_items='true');

--
-- Name: payment_id_order_id; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS payment_id_order_id ON public.payment USING btree (order_id) WITH (deduplicate_items='false');

--
-- Name: payment_id_status_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS payment_id_status_id_idx ON public.payment USING btree (status_id) WITH (deduplicate_items='false');

--
-- Name: payment_meli_id_idx; Type: INDEX; Schema: public
--
CREATE INDEX IF NOT EXISTS payment_meli_id_idx ON public.payment_mercadopago USING btree (id) WITH (deduplicate_items='false');
