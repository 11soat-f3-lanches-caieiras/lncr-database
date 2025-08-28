--
-- PostgreSQL Tables
-- Definição de todas as tabelas do sistema
--

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    document_number character varying(255),
    email character varying(255),
    name character varying(255)
);

ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_order (
    id integer NOT NULL,
    created timestamp(6) without time zone,
    customer_id integer,
    status_id integer,
    total_cost double precision,
    updated timestamp(6) without time zone
);

ALTER TABLE public.customer_order OWNER TO postgres;

--
-- Name: customer_order_food_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_order_food_item (
    id integer NOT NULL,
    food_item_id integer,
    notes character varying(255),
    order_id integer,
    price double precision
);

ALTER TABLE public.customer_order_food_item OWNER TO postgres;

--
-- Name: food_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_item (
    id integer NOT NULL,
    category_id integer,
    description character varying(255),
    name character varying(255),
    price double precision
);

ALTER TABLE public.food_item OWNER TO postgres;

--
-- Name: food_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_item_image (
    id integer NOT NULL,
    file_name character varying(255),
    food_item_id integer
);

ALTER TABLE public.food_item_image OWNER TO postgres;

--
-- Name: kitchen_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kitchen_order (
    id integer NOT NULL,
    created timestamp(6) without time zone,
    customer_order_id integer,
    status_id integer,
    updated timestamp(6) without time zone
);

ALTER TABLE public.kitchen_order OWNER TO postgres;

--
-- Name: kitchen_order_food_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kitchen_order_food_item (
    id integer NOT NULL,
    description character varying(255),
    kitchen_order_id integer,
    name character varying(255),
    notes character varying(255)
);

ALTER TABLE public.kitchen_order_food_item OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    artefact_id integer,
    created timestamp(6) without time zone,
    message character varying(255),
    notification_type character varying(255)
);

ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
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

ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_mercadopago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_mercadopago (
    meli_id character varying(255),
    qr_data character varying(255),
    id integer NOT NULL
);

ALTER TABLE public.payment_mercadopago OWNER TO postgres;
