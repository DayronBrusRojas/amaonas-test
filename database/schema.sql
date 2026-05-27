--
-- PostgreSQL database dump
--

\restrict dpMVX546br1ZrJAKFvng5P0szFX62vMDgJx6v3XvhKv0Lsdld6Q5e7rVEqcVkHO

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-05-19 23:03:32

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 3079 OID 17391)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 2 (class 3079 OID 17380)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 922 (class 1247 OID 17512)
-- Name: accion_auditoria; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.accion_auditoria AS ENUM (
    'CREATE',
    'UPDATE',
    'DELETE',
    'LOGIN',
    'LOGOUT'
);


ALTER TYPE public.accion_auditoria OWNER TO postgres;

--
-- TOC entry 910 (class 1247 OID 17478)
-- Name: categoria_producto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.categoria_producto AS ENUM (
    'CIENCIA',
    'ARQUITECTURA',
    'EDUCATIVO',
    'INCLUSIVO'
);


ALTER TYPE public.categoria_producto OWNER TO postgres;

--
-- TOC entry 919 (class 1247 OID 17502)
-- Name: estado_pago; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago AS ENUM (
    'PENDIENTE_ADELANTO',
    'ADELANTO_CONFIRMADO',
    'PENDIENTE_FINAL',
    'COMPLETADO'
);


ALTER TYPE public.estado_pago OWNER TO postgres;

--
-- TOC entry 913 (class 1247 OID 17488)
-- Name: estado_solicitud; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_solicitud AS ENUM (
    'PENDIENTE',
    'PROCESANDO',
    'COMPLETADO'
);


ALTER TYPE public.estado_solicitud OWNER TO postgres;

--
-- TOC entry 916 (class 1247 OID 17496)
-- Name: tipo_remitente; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_remitente AS ENUM (
    'CLIENT',
    'VENDOR'
);


ALTER TYPE public.tipo_remitente OWNER TO postgres;

--
-- TOC entry 907 (class 1247 OID 17473)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'CLIENT',
    'ADMIN'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 17763)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 231 (class 1259 OID 17736)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id uuid NOT NULL,
    accion public.accion_auditoria NOT NULL,
    user_id uuid,
    cambios jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE audit_logs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.audit_logs IS 'Registro de auditoría de cambios importantes';


--
-- TOC entry 228 (class 1259 OID 17674)
-- Name: budget_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budget_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    presupuesto_id uuid NOT NULL,
    material_id uuid NOT NULL,
    cantidad numeric(10,2) NOT NULL,
    costo_unitario numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT budget_items_cantidad_check CHECK ((cantidad > (0)::numeric)),
    CONSTRAINT budget_items_costo_unitario_check CHECK ((costo_unitario > (0)::numeric))
);


ALTER TABLE public.budget_items OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE budget_items; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.budget_items IS 'Materiales incluidos en cada presupuesto';


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN budget_items.costo_unitario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budget_items.costo_unitario IS 'Snapshot del precio al momento de crear (histórico)';


--
-- TOC entry 227 (class 1259 OID 17653)
-- Name: budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budgets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    solicitud_id uuid NOT NULL,
    nombre character varying(200) NOT NULL,
    descripcion text,
    mano_de_obra numeric(10,2) DEFAULT 0 NOT NULL,
    margen_ganancia integer DEFAULT 30 NOT NULL,
    servicio_explicacion jsonb,
    adelanto jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT budgets_mano_de_obra_check CHECK ((mano_de_obra >= (0)::numeric)),
    CONSTRAINT budgets_margen_ganancia_check CHECK (((margen_ganancia >= 0) AND (margen_ganancia <= 100)))
);


ALTER TABLE public.budgets OWNER TO postgres;

--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE budgets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.budgets IS 'Presupuestos elaborados por vendedores';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN budgets.servicio_explicacion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budgets.servicio_explicacion IS 'JSON: {incluido, precio, duracion, tipo_evento, cantidad_personas}';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN budgets.adelanto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budgets.adelanto IS 'JSON: {requerido, porcentaje, monto}';


--
-- TOC entry 221 (class 1259 OID 17551)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    orden integer DEFAULT 0
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.categories IS 'Categorías de maquetas educativas';


--
-- TOC entry 225 (class 1259 OID 17608)
-- Name: complete_kits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complete_kits (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    producto_id uuid NOT NULL,
    precio_kit numeric(10,2) NOT NULL,
    descripcion text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT complete_kits_precio_kit_check CHECK ((precio_kit > (0)::numeric))
);


ALTER TABLE public.complete_kits OWNER TO postgres;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE complete_kits; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.complete_kits IS 'Precios de kits de materiales para armar';


--
-- TOC entry 224 (class 1259 OID 17590)
-- Name: maqueta_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maqueta_prices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    producto_id uuid NOT NULL,
    precio_completa numeric(10,2) NOT NULL,
    descripcion text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT maqueta_prices_precio_completa_check CHECK ((precio_completa > (0)::numeric))
);


ALTER TABLE public.maqueta_prices OWNER TO postgres;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE maqueta_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.maqueta_prices IS 'Precios fijos para maquetas completas ya armadas';


--
-- TOC entry 223 (class 1259 OID 17577)
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(100) NOT NULL,
    unidad character varying(20) NOT NULL,
    costo_compra numeric(10,2) NOT NULL,
    costo_venta numeric(10,2) NOT NULL,
    stock_actual integer DEFAULT 0 NOT NULL,
    categoria character varying(50),
    proveedor character varying(100),
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT materials_costo_compra_check CHECK ((costo_compra > (0)::numeric)),
    CONSTRAINT materials_costo_venta_check CHECK ((costo_venta > (0)::numeric)),
    CONSTRAINT materials_stock_actual_check CHECK ((stock_actual >= 0))
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.materials IS 'Inventario de materiales para fabricación';


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN materials.costo_compra; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.costo_compra IS 'Lo que pagó el vendedor al proveedor';


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN materials.costo_venta; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.costo_venta IS 'Lo que se cobra al cliente en presupuestos';


--
-- TOC entry 229 (class 1259 OID 17695)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    solicitud_id uuid NOT NULL,
    remitente public.tipo_remitente NOT NULL,
    remitente_id uuid NOT NULL,
    mensaje text NOT NULL,
    presupuesto_adjunto boolean DEFAULT false,
    presupuesto_total numeric(10,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT check_presupuesto CHECK (((NOT presupuesto_adjunto) OR (presupuesto_adjunto AND (presupuesto_total IS NOT NULL))))
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE messages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.messages IS 'Sistema de chat entre clientes y vendedores';


--
-- TOC entry 230 (class 1259 OID 17711)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    solicitud_id uuid NOT NULL,
    presupuesto_id uuid NOT NULL,
    monto_total numeric(10,2) NOT NULL,
    estado public.estado_pago DEFAULT 'PENDIENTE_ADELANTO'::public.estado_pago NOT NULL,
    adelanto jsonb,
    pago_final jsonb,
    entregado boolean DEFAULT false NOT NULL,
    fecha_entrega timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT payments_monto_total_check CHECK ((monto_total > (0)::numeric))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.payments IS 'Control de pagos con adelanto y pago final';


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN payments.adelanto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.adelanto IS 'JSON: {requerido, monto, pagado, evidencia_url, fecha_pago}';


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN payments.pago_final; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.pago_final IS 'JSON: {monto, pagado, evidencia_url, fecha_pago}';


--
-- TOC entry 222 (class 1259 OID 17559)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    titulo character varying(200) NOT NULL,
    descripcion text,
    descripcion_detallada text,
    categoria_id character varying(50) NOT NULL,
    image_url character varying(500),
    materiales text[],
    grado_escolar character varying(50),
    ocasion text[],
    materiales_reciclables boolean DEFAULT false,
    stock integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT products_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.products IS 'Catálogo de maquetas educativas';


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN products.materiales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.materiales IS 'Lista de materiales utilizados en la maqueta';


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN products.ocasion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.ocasion IS 'Ocasiones especiales (Feria de Ciencias, Día del Logro, etc)';


--
-- TOC entry 226 (class 1259 OID 17626)
-- Name: purchase_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_requests (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    usuario_id uuid NOT NULL,
    producto_id uuid,
    cliente_nombre character varying(255) NOT NULL,
    cliente_email character varying(150) NOT NULL,
    cliente_telefono character varying(15),
    producto_nombre character varying(200) NOT NULL,
    is_kit boolean DEFAULT false NOT NULL,
    is_custom boolean DEFAULT false NOT NULL,
    estado public.estado_solicitud DEFAULT 'PENDIENTE'::public.estado_solicitud NOT NULL,
    mensaje text,
    descripcion_personalizacion text,
    materiales_seleccionados text[],
    materiales_deseados text,
    kits_maquetas jsonb,
    solicitar_explicacion boolean DEFAULT false,
    tipo_evento character varying(100),
    cantidad_personas integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT check_kits CHECK (((NOT is_kit) OR (is_kit AND (kits_maquetas IS NOT NULL)))),
    CONSTRAINT check_personalizacion CHECK (((NOT is_custom) OR (is_custom AND (descripcion_personalizacion IS NOT NULL)))),
    CONSTRAINT purchase_requests_cantidad_personas_check CHECK ((cantidad_personas > 0))
);


ALTER TABLE public.purchase_requests OWNER TO postgres;

--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE purchase_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.purchase_requests IS 'Solicitudes de compra realizadas por clientes';


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN purchase_requests.kits_maquetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.kits_maquetas IS 'Array JSON con productos y cantidades para kits personalizados';


--
-- TOC entry 219 (class 1259 OID 17523)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    telefono character varying(15),
    role public.user_role DEFAULT 'CLIENT'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT check_email_format CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'::text))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Clientes del sistema';


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN users.deleted_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.deleted_at IS 'Si tiene valor, el usuario está eliminado (soft delete)';


--
-- TOC entry 232 (class 1259 OID 17773)
-- Name: v_inventory_value; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_inventory_value AS
 SELECT sum(((stock_actual)::numeric * costo_compra)) AS valor_total_inventario,
    count(*) AS total_materiales,
    sum(
        CASE
            WHEN (stock_actual < 10) THEN 1
            ELSE 0
        END) AS materiales_stock_bajo
   FROM public.materials
  WHERE ((deleted_at IS NULL) AND (activo = true));


ALTER VIEW public.v_inventory_value OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17777)
-- Name: v_purchase_stats; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_purchase_stats AS
 SELECT count(*) AS total_solicitudes,
    count(*) FILTER (WHERE (estado = 'PENDIENTE'::public.estado_solicitud)) AS pendientes,
    count(*) FILTER (WHERE (estado = 'PROCESANDO'::public.estado_solicitud)) AS procesando,
    count(*) FILTER (WHERE (estado = 'COMPLETADO'::public.estado_solicitud)) AS completados,
    count(*) FILTER (WHERE (is_custom = true)) AS personalizadas,
    count(*) FILTER (WHERE (is_kit = true)) AS kits
   FROM public.purchase_requests
  WHERE (deleted_at IS NULL);


ALTER VIEW public.v_purchase_stats OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17781)
-- Name: v_top_products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_top_products AS
 SELECT p.id,
    p.titulo,
    p.categoria_id,
    p.image_url,
    count(pr.id) AS total_solicitudes
   FROM (public.products p
     LEFT JOIN public.purchase_requests pr ON (((p.id = pr.producto_id) AND (pr.deleted_at IS NULL))))
  WHERE (p.deleted_at IS NULL)
  GROUP BY p.id, p.titulo, p.categoria_id, p.image_url
  ORDER BY (count(pr.id)) DESC
 LIMIT 10;


ALTER VIEW public.v_top_products OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17537)
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendors (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    role public.user_role DEFAULT 'ADMIN'::public.user_role NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE vendors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.vendors IS 'Vendedores/administradores del sistema';


--
-- TOC entry 5001 (class 2606 OID 17744)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4985 (class 2606 OID 17682)
-- Name: budget_items budget_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4980 (class 2606 OID 17666)
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- TOC entry 4982 (class 2606 OID 17668)
-- Name: budgets budgets_solicitud_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_solicitud_id_key UNIQUE (solicitud_id);


--
-- TOC entry 4956 (class 2606 OID 17558)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 17618)
-- Name: complete_kits complete_kits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_kits
    ADD CONSTRAINT complete_kits_pkey PRIMARY KEY (id);


--
-- TOC entry 4973 (class 2606 OID 17620)
-- Name: complete_kits complete_kits_producto_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_kits
    ADD CONSTRAINT complete_kits_producto_id_key UNIQUE (producto_id);


--
-- TOC entry 4967 (class 2606 OID 17600)
-- Name: maqueta_prices maqueta_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maqueta_prices
    ADD CONSTRAINT maqueta_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4969 (class 2606 OID 17602)
-- Name: maqueta_prices maqueta_prices_producto_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maqueta_prices
    ADD CONSTRAINT maqueta_prices_producto_id_key UNIQUE (producto_id);


--
-- TOC entry 4965 (class 2606 OID 17589)
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- TOC entry 4993 (class 2606 OID 17705)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 4997 (class 2606 OID 17723)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 4999 (class 2606 OID 17725)
-- Name: payments payments_solicitud_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_solicitud_id_key UNIQUE (solicitud_id);


--
-- TOC entry 4961 (class 2606 OID 17571)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4978 (class 2606 OID 17642)
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4989 (class 2606 OID 17684)
-- Name: budget_items unique_presupuesto_material; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT unique_presupuesto_material UNIQUE (presupuesto_id, material_id);


--
-- TOC entry 4948 (class 2606 OID 17536)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4950 (class 2606 OID 17534)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 17550)
-- Name: vendors vendors_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_email_key UNIQUE (email);


--
-- TOC entry 4954 (class 2606 OID 17548)
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- TOC entry 4986 (class 1259 OID 17758)
-- Name: idx_budget_items_material; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budget_items_material ON public.budget_items USING btree (material_id);


--
-- TOC entry 4987 (class 1259 OID 17757)
-- Name: idx_budget_items_presupuesto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budget_items_presupuesto ON public.budget_items USING btree (presupuesto_id);


--
-- TOC entry 4983 (class 1259 OID 17756)
-- Name: idx_budgets_solicitud; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_solicitud ON public.budgets USING btree (solicitud_id);


--
-- TOC entry 4962 (class 1259 OID 17752)
-- Name: idx_materials_activo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_activo ON public.materials USING btree (activo);


--
-- TOC entry 4963 (class 1259 OID 17751)
-- Name: idx_materials_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_nombre ON public.materials USING btree (nombre) WHERE (deleted_at IS NULL);


--
-- TOC entry 4990 (class 1259 OID 17760)
-- Name: idx_messages_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_fecha ON public.messages USING btree (created_at DESC);


--
-- TOC entry 4991 (class 1259 OID 17759)
-- Name: idx_messages_solicitud; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_solicitud ON public.messages USING btree (solicitud_id);


--
-- TOC entry 4994 (class 1259 OID 17762)
-- Name: idx_payments_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_estado ON public.payments USING btree (estado);


--
-- TOC entry 4995 (class 1259 OID 17761)
-- Name: idx_payments_solicitud; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_solicitud ON public.payments USING btree (solicitud_id);


--
-- TOC entry 4957 (class 1259 OID 17748)
-- Name: idx_products_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_categoria ON public.products USING btree (categoria_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4958 (class 1259 OID 17750)
-- Name: idx_products_descripcion_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_descripcion_trgm ON public.products USING gin (descripcion public.gin_trgm_ops);


--
-- TOC entry 4959 (class 1259 OID 17749)
-- Name: idx_products_titulo_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_titulo_trgm ON public.products USING gin (titulo public.gin_trgm_ops);


--
-- TOC entry 4974 (class 1259 OID 17754)
-- Name: idx_purchase_requests_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_estado ON public.purchase_requests USING btree (estado);


--
-- TOC entry 4975 (class 1259 OID 17755)
-- Name: idx_purchase_requests_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_fecha ON public.purchase_requests USING btree (created_at DESC);


--
-- TOC entry 4976 (class 1259 OID 17753)
-- Name: idx_purchase_requests_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_usuario ON public.purchase_requests USING btree (usuario_id);


--
-- TOC entry 4945 (class 1259 OID 17746)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 4946 (class 1259 OID 17747)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role) WHERE (deleted_at IS NULL);


--
-- TOC entry 5020 (class 2620 OID 17771)
-- Name: budgets update_budgets_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5018 (class 2620 OID 17769)
-- Name: complete_kits update_complete_kits_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_complete_kits_updated_at BEFORE UPDATE ON public.complete_kits FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5017 (class 2620 OID 17768)
-- Name: maqueta_prices update_maqueta_prices_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_maqueta_prices_updated_at BEFORE UPDATE ON public.maqueta_prices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5016 (class 2620 OID 17767)
-- Name: materials update_materials_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON public.materials FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5021 (class 2620 OID 17772)
-- Name: payments update_payments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5015 (class 2620 OID 17766)
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5019 (class 2620 OID 17770)
-- Name: purchase_requests update_purchase_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_purchase_requests_updated_at BEFORE UPDATE ON public.purchase_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5013 (class 2620 OID 17764)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5014 (class 2620 OID 17765)
-- Name: vendors update_vendors_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_vendors_updated_at BEFORE UPDATE ON public.vendors FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5008 (class 2606 OID 17690)
-- Name: budget_items budget_items_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE RESTRICT;


--
-- TOC entry 5009 (class 2606 OID 17685)
-- Name: budget_items budget_items_presupuesto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_presupuesto_id_fkey FOREIGN KEY (presupuesto_id) REFERENCES public.budgets(id) ON DELETE CASCADE;


--
-- TOC entry 5007 (class 2606 OID 17669)
-- Name: budgets budgets_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_solicitud_id_fkey FOREIGN KEY (solicitud_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5004 (class 2606 OID 17621)
-- Name: complete_kits complete_kits_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_kits
    ADD CONSTRAINT complete_kits_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 5003 (class 2606 OID 17603)
-- Name: maqueta_prices maqueta_prices_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maqueta_prices
    ADD CONSTRAINT maqueta_prices_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 5010 (class 2606 OID 17706)
-- Name: messages messages_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_solicitud_id_fkey FOREIGN KEY (solicitud_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5011 (class 2606 OID 17731)
-- Name: payments payments_presupuesto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_presupuesto_id_fkey FOREIGN KEY (presupuesto_id) REFERENCES public.budgets(id) ON DELETE RESTRICT;


--
-- TOC entry 5012 (class 2606 OID 17726)
-- Name: payments payments_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_solicitud_id_fkey FOREIGN KEY (solicitud_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5002 (class 2606 OID 17572)
-- Name: products products_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- TOC entry 5005 (class 2606 OID 17648)
-- Name: purchase_requests purchase_requests_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- TOC entry 5006 (class 2606 OID 17643)
-- Name: purchase_requests purchase_requests_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-05-19 23:03:32

--
-- PostgreSQL database dump complete
--

\unrestrict dpMVX546br1ZrJAKFvng5P0szFX62vMDgJx6v3XvhKv0Lsdld6Q5e7rVEqcVkHO

