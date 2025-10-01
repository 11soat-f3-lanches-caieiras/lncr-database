--
-- PostgreSQL Sequences
-- Definição de todas as sequências para auto-incremento
--

-- Sequência para customer
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'customer_id_seq') THEN
        CREATE SEQUENCE public.customer_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);
        ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;
    END IF;
END $$;

-- Sequência para customer_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'customer_order_id_seq') THEN
        CREATE SEQUENCE public.customer_order_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.customer_order ALTER COLUMN id SET DEFAULT nextval('public.customer_order_id_seq'::regclass);
        ALTER SEQUENCE public.customer_order_id_seq OWNED BY public.customer_order.id;
    END IF;
END $$;

-- Sequência para customer_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'customer_order_food_item_id_seq') THEN
        CREATE SEQUENCE public.customer_order_food_item_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.customer_order_food_item ALTER COLUMN id SET DEFAULT nextval('public.customer_order_food_item_id_seq'::regclass);
        ALTER SEQUENCE public.customer_order_food_item_id_seq OWNED BY public.customer_order_food_item.id;
    END IF;
END $$;

-- Sequência para food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'food_item_id_seq') THEN
        CREATE SEQUENCE public.food_item_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.food_item ALTER COLUMN id SET DEFAULT nextval('public.food_item_id_seq'::regclass);
        ALTER SEQUENCE public.food_item_id_seq OWNED BY public.food_item.id;
    END IF;
END $$;

-- Sequência para food_item_image
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'food_item_image_id_seq') THEN
        CREATE SEQUENCE public.food_item_image_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.food_item_image ALTER COLUMN id SET DEFAULT nextval('public.food_item_image_id_seq'::regclass);
        ALTER SEQUENCE public.food_item_image_id_seq OWNED BY public.food_item_image.id;
    END IF;
END $$;

-- Sequência para kitchen_order
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'kitchen_order_id_seq') THEN
        CREATE SEQUENCE public.kitchen_order_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.kitchen_order ALTER COLUMN id SET DEFAULT nextval('public.kitchen_order_id_seq'::regclass);
        ALTER SEQUENCE public.kitchen_order_id_seq OWNED BY public.kitchen_order.id;
    END IF;
END $$;

-- Sequência para kitchen_order_food_item
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'kitchen_order_food_item_id_seq') THEN
        CREATE SEQUENCE public.kitchen_order_food_item_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.kitchen_order_food_item ALTER COLUMN id SET DEFAULT nextval('public.kitchen_order_food_item_id_seq'::regclass);
        ALTER SEQUENCE public.kitchen_order_food_item_id_seq OWNED BY public.kitchen_order_food_item.id;
    END IF;
END $$;

-- Sequência para notifications
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'notifications_id_seq') THEN
        CREATE SEQUENCE public.notifications_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
        ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;
    END IF;
END $$;

-- Sequência para payment
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = 'payment_id_seq') THEN
        CREATE SEQUENCE public.payment_id_seq
            START WITH 1
            INCREMENT BY 1
            NO MINVALUE
            NO MAXVALUE
            CACHE 1;

        ALTER TABLE public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);
        ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;
    END IF;
END $$;
