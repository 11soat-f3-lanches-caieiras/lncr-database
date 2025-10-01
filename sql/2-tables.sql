--
-- PostgreSQL Tables
-- Definição de todas as tabelas do sistema
--

--
-- Name: customer; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.customer (
    id integer NOT NULL,
    document_number character varying(255),
    email character varying(255),
    name character varying(255)
);

--
-- Name: customer_order; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.customer_order (
    id integer NOT NULL,
    created timestamp(6) without time zone,
    customer_id integer,
    status_id integer,
    total_cost double precision,
    updated timestamp(6) without time zone
);

--
-- Name: customer_order_food_item; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.customer_order_food_item (
    id integer NOT NULL,
    food_item_id integer,
    notes character varying(255),
    order_id integer,
    price double precision
);

--
-- Name: food_item; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.food_item (
    id integer NOT NULL,
    category_id integer,
    description character varying(255),
    name character varying(255),
    price double precision
);

--
-- Name: food_item_image; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.food_item_image (
    id integer NOT NULL,
    file_name character varying(255),
    food_item_id integer
);

--
-- Name: kitchen_order; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.kitchen_order (
    id integer NOT NULL,
    created timestamp(6) without time zone,
    customer_order_id integer,
    status_id integer,
    updated timestamp(6) without time zone
);

--
-- Name: kitchen_order_food_item; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.kitchen_order_food_item (
    id integer NOT NULL,
    description character varying(255),
    kitchen_order_id integer,
    name character varying(255),
    notes character varying(255)
);

--
-- Name: notifications; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.notifications (
    id integer NOT NULL,
    artefact_id integer,
    created timestamp(6) without time zone,
    message character varying(255),
    notification_type character varying(255)
);

--
-- Name: payment; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.payment (
    id integer NOT NULL,
    amount double precision,
    created timestamp(6) without time zone,
    external_payment_id character varying(255),
    order_id integer,
    payment_method character varying(255),
    payment_provider character varying(255),
    status_id integer,
    updated timestamp(6) without time zone
);

--
-- Name: payment_mercadopago; Type: TABLE; Schema: public
--

CREATE TABLE IF NOT EXISTS public.payment_mercadopago (
    meli_id character varying(255),
    qr_data character varying(255),
    id integer NOT NULL
);
