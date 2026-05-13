--
-- PostgreSQL database dump
--

\restrict 4JScm1ibRAHDS7H8XCXFd27dB9axdTI9hIjVGL6tvYVneTQMTcIMPdkl7ctnftM

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-05-13 14:24:15

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
-- TOC entry 11 (class 2615 OID 16563)
-- Name: audit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 16564)
-- Name: temp; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA temp;


ALTER SCHEMA temp OWNER TO postgres;

--
-- TOC entry 6 (class 3079 OID 16526)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 5461 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'Monitoreo de performance de queries';


--
-- TOC entry 4 (class 3079 OID 16438)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 5462 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'Búsqueda de texto con trigram para productos';


--
-- TOC entry 3 (class 3079 OID 16401)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5463 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'Encriptación de passwords con bcrypt';


--
-- TOC entry 5 (class 3079 OID 16519)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 5464 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'Búsqueda sin acentos para mejor UX en español';


--
-- TOC entry 2 (class 3079 OID 16390)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5465 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'Generación de UUIDs para PKs distribuidas';


--
-- TOC entry 1008 (class 1247 OID 16604)
-- Name: audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.audit_action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'SOFT_DELETE'
);


ALTER TYPE public.audit_action OWNER TO postgres;

--
-- TOC entry 999 (class 1247 OID 16576)
-- Name: budget_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.budget_status AS ENUM (
    'borrador',
    'enviado',
    'aceptado',
    'rechazado'
);


ALTER TYPE public.budget_status OWNER TO postgres;

--
-- TOC entry 1023 (class 1247 OID 16658)
-- Name: email; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.email AS character varying(255)
	CONSTRAINT email_check CHECK (((VALUE)::text ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text));


ALTER DOMAIN public.email OWNER TO postgres;

--
-- TOC entry 1020 (class 1247 OID 16650)
-- Name: explanation_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.explanation_type AS ENUM (
    'video',
    'presencial',
    'ambos'
);


ALTER TYPE public.explanation_type OWNER TO postgres;

--
-- TOC entry 1011 (class 1247 OID 16614)
-- Name: material_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.material_category AS ENUM (
    'Base',
    'Estructura',
    'Reciclable',
    'Electrónica',
    'Acabado',
    'Adhesivo',
    'Formas',
    'Moldeable',
    'Textura',
    'Accesorios'
);


ALTER TYPE public.material_category OWNER TO postgres;

--
-- TOC entry 1017 (class 1247 OID 16644)
-- Name: message_sender_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.message_sender_type AS ENUM (
    'client',
    'vendor'
);


ALTER TYPE public.message_sender_type OWNER TO postgres;

--
-- TOC entry 1002 (class 1247 OID 16586)
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'pendiente-adelanto',
    'adelanto-pagado',
    'completado',
    'cancelado'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- TOC entry 1035 (class 1247 OID 16667)
-- Name: percentage; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.percentage AS numeric(5,2)
	CONSTRAINT percentage_check CHECK (((VALUE >= (0)::numeric) AND (VALUE <= (100)::numeric)));


ALTER DOMAIN public.percentage OWNER TO postgres;

--
-- TOC entry 1027 (class 1247 OID 16661)
-- Name: phone_pe; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.phone_pe AS character varying(20)
	CONSTRAINT phone_pe_check CHECK ((((VALUE)::text ~ '^\+51\s?[0-9]{3}\s?[0-9]{3}\s?[0-9]{3}$'::text) OR ((VALUE)::text ~ '^[0-9]{9}$'::text)));


ALTER DOMAIN public.phone_pe OWNER TO postgres;

--
-- TOC entry 1031 (class 1247 OID 16664)
-- Name: positive_decimal; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.positive_decimal AS numeric(10,2)
	CONSTRAINT positive_decimal_check CHECK ((VALUE >= (0)::numeric));


ALTER DOMAIN public.positive_decimal OWNER TO postgres;

--
-- TOC entry 1039 (class 1247 OID 16670)
-- Name: positive_integer; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.positive_integer AS integer
	CONSTRAINT positive_integer_check CHECK ((VALUE >= 0));


ALTER DOMAIN public.positive_integer OWNER TO postgres;

--
-- TOC entry 996 (class 1247 OID 16566)
-- Name: purchase_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.purchase_status AS ENUM (
    'pendiente',
    'procesando',
    'completado',
    'cancelado'
);


ALTER TYPE public.purchase_status OWNER TO postgres;

--
-- TOC entry 1014 (class 1247 OID 16636)
-- Name: stock_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.stock_level AS ENUM (
    'disponible',
    'stock-bajo',
    'agotado'
);


ALTER TYPE public.stock_level OWNER TO postgres;

--
-- TOC entry 1005 (class 1247 OID 16596)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'client',
    'vendor',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 17115)
-- Name: analyze_index_usage(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.analyze_index_usage() RETURNS TABLE(schemaname text, tablename text, indexname text, index_scans bigint, tuples_read bigint, tuples_fetched bigint, size_mb numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        psui.schemaname::TEXT,
        psui.tablename::TEXT,
        psui.indexname::TEXT,
        psui.idx_scan,
        psui.idx_tup_read,
        psui.idx_tup_fetch,
        ROUND(pg_relation_size(psui.indexrelid)::NUMERIC / 1024 / 1024, 2) as size_mb
    FROM pg_stat_user_indexes psui
    WHERE psui.schemaname IN ('public', 'audit')
    ORDER BY psui.idx_scan DESC;
END;
$$;


ALTER FUNCTION public.analyze_index_usage() OWNER TO postgres;

--
-- TOC entry 5466 (class 0 OID 0)
-- Dependencies: 323
-- Name: FUNCTION analyze_index_usage(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.analyze_index_usage() IS 'Muestra estadísticas de uso de índices para identificar índices sin usar.
Ejecutar: SELECT * FROM analyze_index_usage() WHERE index_scans = 0;';


--
-- TOC entry 286 (class 1255 OID 17123)
-- Name: audit_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.audit_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_action audit_action;
BEGIN
    -- Determinar tipo de acción
    IF TG_OP = 'DELETE' THEN
        v_action := 'DELETE';
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL THEN
            v_action := 'SOFT_DELETE';
        ELSE
            v_action := 'UPDATE';
        END IF;
    ELSIF TG_OP = 'INSERT' THEN
        v_action := 'INSERT';
    END IF;

    -- Insertar en audit_logs
    INSERT INTO audit.audit_logs (
        table_name,
        record_id,
        action,
        old_data,
        new_data,
        created_at
    ) VALUES (
        TG_TABLE_NAME,
        COALESCE(NEW.id, OLD.id),
        v_action,
        CASE WHEN TG_OP != 'INSERT' THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW) ELSE NULL END,
        NOW()
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.audit_trigger_function() OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 17118)
-- Name: calculate_budget_total(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_budget_total(p_budget_id uuid) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_materials_cost DECIMAL(10,2);
    v_mano_obra DECIMAL(10,2);
    v_margen DECIMAL(5,2);
    v_servicio_precio DECIMAL(10,2);
    v_subtotal DECIMAL(10,2);
    v_ganancia DECIMAL(10,2);
    v_has_maqueta_completa BOOLEAN;
BEGIN
    -- Obtener costos adicionales del presupuesto
    SELECT mano_de_obra, margen_ganancia
    INTO v_mano_obra, v_margen
    FROM budgets
    WHERE id = p_budget_id;

    -- Calcular costo de materiales/items
    SELECT COALESCE(SUM(
        CASE
            WHEN is_kit_completo THEN kit_precio * cantidad
            ELSE costo_unitario * cantidad
        END
    ), 0)
    INTO v_materials_cost
    FROM budget_items
    WHERE budget_id = p_budget_id;

    -- Detectar si tiene maqueta completa
    SELECT EXISTS(
        SELECT 1
        FROM budget_items
        WHERE budget_id = p_budget_id
          AND is_kit_completo = TRUE
          AND kit_completo_id LIKE 'maqueta-%'
    ) INTO v_has_maqueta_completa;

    -- Obtener precio de servicio de explicación
    SELECT COALESCE(
        (servicio_explicacion->>'precio')::DECIMAL(10,2),
        0
    )
    INTO v_servicio_precio
    FROM budgets
    WHERE id = p_budget_id
      AND (servicio_explicacion->>'incluido')::BOOLEAN = TRUE;

    -- Calcular total según tipo
    IF v_has_maqueta_completa THEN
        -- Maqueta completa: NO se suma mano de obra ni margen
        RETURN v_materials_cost + v_servicio_precio;
    ELSE
        -- Personalizado: se suma todo
        v_subtotal := v_materials_cost + v_mano_obra + v_servicio_precio;
        v_ganancia := v_subtotal * (v_margen / 100);
        RETURN v_subtotal + v_ganancia;
    END IF;
END;
$$;


ALTER FUNCTION public.calculate_budget_total(p_budget_id uuid) OWNER TO postgres;

--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 310
-- Name: FUNCTION calculate_budget_total(p_budget_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.calculate_budget_total(p_budget_id uuid) IS 'Calcula el total de un presupuesto considerando:
- Si tiene precio de maqueta completa: solo suma materiales + servicio
- Si es personalizado: suma materiales + mano de obra + servicio + margen de ganancia';


--
-- TOC entry 320 (class 1255 OID 17131)
-- Name: cleanup_expired_sessions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_expired_sessions() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_deleted INTEGER;
BEGIN
    DELETE FROM user_sessions
    WHERE expires_at < NOW();

    GET DIAGNOSTICS v_deleted = ROW_COUNT;

    RETURN v_deleted;
END;
$$;


ALTER FUNCTION public.cleanup_expired_sessions() OWNER TO postgres;

--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 320
-- Name: FUNCTION cleanup_expired_sessions(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.cleanup_expired_sessions() IS 'Elimina sesiones expiradas. Ejecutar periódicamente con cron.
Ejemplo: SELECT cleanup_expired_sessions();';


--
-- TOC entry 347 (class 1255 OID 17133)
-- Name: cleanup_old_soft_deletes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_old_soft_deletes(p_months integer DEFAULT 12) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_deleted INTEGER;
BEGIN
    -- Eliminar purchase_requests con más de X meses soft deleted
    DELETE FROM purchase_requests
    WHERE deleted_at < NOW() - (p_months || ' months')::INTERVAL;

    GET DIAGNOSTICS v_deleted = ROW_COUNT;

    RETURN v_deleted;
END;
$$;


ALTER FUNCTION public.cleanup_old_soft_deletes(p_months integer) OWNER TO postgres;

--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 347
-- Name: FUNCTION cleanup_old_soft_deletes(p_months integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.cleanup_old_soft_deletes(p_months integer) IS 'Elimina permanentemente registros soft-deleted antiguos.
Por defecto: mayores a 12 meses.';


--
-- TOC entry 282 (class 1255 OID 17132)
-- Name: cleanup_temporary_files(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_temporary_files() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_deleted INTEGER;
BEGIN
    DELETE FROM file_uploads
    WHERE is_temporary = TRUE
      AND expires_at < NOW();

    GET DIAGNOSTICS v_deleted = ROW_COUNT;

    RETURN v_deleted;
END;
$$;


ALTER FUNCTION public.cleanup_temporary_files() OWNER TO postgres;

--
-- TOC entry 5470 (class 0 OID 0)
-- Dependencies: 282
-- Name: FUNCTION cleanup_temporary_files(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.cleanup_temporary_files() IS 'Elimina archivos temporales expirados';


--
-- TOC entry 274 (class 1255 OID 17121)
-- Name: create_budget_from_request(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_budget_from_request(p_request_id uuid, p_vendor_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_budget_id UUID;
    v_request RECORD;
    v_precio_maqueta RECORD;
    v_kit_completo RECORD;
BEGIN
    -- Obtener datos de la solicitud
    SELECT * INTO v_request
    FROM purchase_requests
    WHERE id = p_request_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Solicitud no encontrada: %', p_request_id;
    END IF;

    -- Crear presupuesto
    INSERT INTO budgets (
        request_id,
        vendor_id,
        cliente_nombre,
        cliente_email,
        cliente_telefono,
        nombre,
        descripcion,
        status,
        servicio_explicacion,
        adelanto
    ) VALUES (
        p_request_id,
        p_vendor_id,
        v_request.cliente_nombre,
        v_request.cliente_email,
        v_request.cliente_telefono,
        'Presupuesto - ' || v_request.producto_nombre,
        v_request.mensaje,
        'borrador',
        CASE
            WHEN v_request.solicitar_explicacion THEN
                jsonb_build_object(
                    'incluido', true,
                    'tipoEvento', v_request.tipo_evento,
                    'cantidadPersonas', v_request.cantidad_personas,
                    'duracion', 90,
                    'precio', 50.00
                )
            ELSE
                jsonb_build_object('incluido', false)
        END,
        jsonb_build_object(
            'requerido', false,
            'monto', 0,
            'porcentaje', 50,
            'pagado', false
        )
    ) RETURNING id INTO v_budget_id;

    -- Agregar items automáticamente según tipo de solicitud
    IF v_request.is_kit = FALSE AND v_request.is_custom = FALSE AND v_request.product_id IS NOT NULL THEN
        -- Solicitud normal de catálogo: buscar precio de maqueta
        SELECT * INTO v_precio_maqueta
        FROM get_product_price_maqueta(v_request.product_id);

        IF FOUND THEN
            -- Insertar precio de maqueta completa
            INSERT INTO budget_items (
                budget_id,
                cantidad,
                is_kit_completo,
                kit_completo_id,
                kit_precio,
                costo_unitario
            ) VALUES (
                v_budget_id,
                1,
                TRUE,
                'maqueta-' || v_precio_maqueta.id::TEXT,
                v_precio_maqueta.precio,
                v_precio_maqueta.precio
            );
        END IF;
    ELSIF v_request.is_kit = TRUE THEN
        -- Solicitud de kit: cargar kits completos
        -- TODO: Implementar carga automática de kits desde JSONB
        NULL;
    END IF;

    -- Marcar presupuesto como creado en la solicitud
    UPDATE purchase_requests
    SET budget_id = v_budget_id,
        budget_created = TRUE,
        status = 'procesando'
    WHERE id = p_request_id;

    RETURN v_budget_id;
END;
$$;


ALTER FUNCTION public.create_budget_from_request(p_request_id uuid, p_vendor_id uuid) OWNER TO postgres;

--
-- TOC entry 5471 (class 0 OID 0)
-- Dependencies: 274
-- Name: FUNCTION create_budget_from_request(p_request_id uuid, p_vendor_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.create_budget_from_request(p_request_id uuid, p_vendor_id uuid) IS 'Crea un presupuesto automático desde una solicitud.
Auto-carga precio de maqueta si existe.
Retorna el ID del presupuesto creado.';


--
-- TOC entry 258 (class 1255 OID 17116)
-- Name: find_duplicate_indexes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_duplicate_indexes() RETURNS TABLE(table_name text, index1 text, index2 text, columns text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.tablename::TEXT,
        i1.indexname::TEXT,
        i2.indexname::TEXT,
        i1.indexdef::TEXT
    FROM pg_indexes i1
    JOIN pg_indexes i2 ON i1.tablename = i2.tablename
        AND i1.indexname < i2.indexname
        AND i1.indexdef = i2.indexdef
    JOIN pg_tables t ON t.tablename = i1.tablename
    WHERE t.schemaname IN ('public', 'audit');
END;
$$;


ALTER FUNCTION public.find_duplicate_indexes() OWNER TO postgres;

--
-- TOC entry 5472 (class 0 OID 0)
-- Dependencies: 258
-- Name: FUNCTION find_duplicate_indexes(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.find_duplicate_indexes() IS 'Detecta índices duplicados que pueden ser eliminados para ahorrar espacio';


--
-- TOC entry 283 (class 1255 OID 16673)
-- Name: generate_slug(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_slug(text_input text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN LOWER(
        REGEXP_REPLACE(
            REGEXP_REPLACE(
                UNACCENT(text_input),
                '[^a-zA-Z0-9\s-]', '', 'g'
            ),
            '\s+', '-', 'g'
        )
    );
END;
$$;


ALTER FUNCTION public.generate_slug(text_input text) OWNER TO postgres;

--
-- TOC entry 5473 (class 0 OID 0)
-- Dependencies: 283
-- Name: FUNCTION generate_slug(text_input text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.generate_slug(text_input text) IS 'Genera un slug URL-friendly desde un texto (ej: "Célula Animal" -> "celula-animal")';


--
-- TOC entry 264 (class 1255 OID 17120)
-- Name: get_product_kit_completo(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_product_kit_completo(p_product_id uuid) RETURNS TABLE(id uuid, precio numeric, descripcion text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        ck.id,
        ck.precio_total,
        ck.descripcion
    FROM complete_kits ck
    WHERE ck.product_id = p_product_id
      AND ck.is_active = TRUE
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_product_kit_completo(p_product_id uuid) OWNER TO postgres;

--
-- TOC entry 5474 (class 0 OID 0)
-- Dependencies: 264
-- Name: FUNCTION get_product_kit_completo(p_product_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.get_product_kit_completo(p_product_id uuid) IS 'Obtiene el kit completo de materiales de un producto si existe';


--
-- TOC entry 306 (class 1255 OID 17119)
-- Name: get_product_price_maqueta(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_product_price_maqueta(p_product_id uuid) RETURNS TABLE(id uuid, precio numeric, descripcion text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        pp.id,
        pp.precio_completa,
        pp.descripcion
    FROM product_prices pp
    WHERE pp.product_id = p_product_id
      AND pp.is_active = TRUE
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_product_price_maqueta(p_product_id uuid) OWNER TO postgres;

--
-- TOC entry 5475 (class 0 OID 0)
-- Dependencies: 306
-- Name: FUNCTION get_product_price_maqueta(p_product_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.get_product_price_maqueta(p_product_id uuid) IS 'Obtiene el precio de maqueta completa de un producto si existe';


--
-- TOC entry 356 (class 1255 OID 16674)
-- Name: hash_password(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hash_password(password text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN crypt(password, gen_salt('bf', 10));
END;
$$;


ALTER FUNCTION public.hash_password(password text) OWNER TO postgres;

--
-- TOC entry 5476 (class 0 OID 0)
-- Dependencies: 356
-- Name: FUNCTION hash_password(password text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.hash_password(password text) IS 'Hashea una contraseña usando bcrypt con cost factor 10';


--
-- TOC entry 329 (class 1255 OID 17130)
-- Name: report_material_usage(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.report_material_usage() RETURNS TABLE(material_id uuid, material_name character varying, times_used bigint, total_quantity numeric)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.nombre,
        COUNT(*) as times_used,
        SUM(bi.cantidad) as total_quantity
    FROM budget_items bi
    JOIN materials m ON m.id = bi.material_id
    WHERE bi.is_kit_completo = FALSE
    GROUP BY m.id, m.nombre
    ORDER BY times_used DESC;
END;
$$;


ALTER FUNCTION public.report_material_usage() OWNER TO postgres;

--
-- TOC entry 5477 (class 0 OID 0)
-- Dependencies: 329
-- Name: FUNCTION report_material_usage(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.report_material_usage() IS 'Muestra qué materiales se usan más frecuentemente en presupuestos';


--
-- TOC entry 280 (class 1255 OID 17128)
-- Name: report_sales_by_period(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.report_sales_by_period(p_date_from date, p_date_to date) RETURNS TABLE(fecha date, total_solicitudes bigint, total_completadas bigint, total_ingresos numeric)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        pr.created_at::DATE as fecha,
        COUNT(*) as total_solicitudes,
        COUNT(*) FILTER (WHERE pr.status = 'completado') as total_completadas,
        COALESCE(SUM(pay.monto_total) FILTER (WHERE pay.status = 'completado'), 0) as total_ingresos
    FROM purchase_requests pr
    LEFT JOIN payments pay ON pay.request_id = pr.id
    WHERE pr.created_at::DATE BETWEEN p_date_from AND p_date_to
      AND pr.deleted_at IS NULL
    GROUP BY pr.created_at::DATE
    ORDER BY fecha DESC;
END;
$$;


ALTER FUNCTION public.report_sales_by_period(p_date_from date, p_date_to date) OWNER TO postgres;

--
-- TOC entry 5478 (class 0 OID 0)
-- Dependencies: 280
-- Name: FUNCTION report_sales_by_period(p_date_from date, p_date_to date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.report_sales_by_period(p_date_from date, p_date_to date) IS 'Genera reporte de ventas por día en un rango de fechas.
Ejemplo: SELECT * FROM report_sales_by_period(''2026-05-01'', ''2026-05-31'');';


--
-- TOC entry 324 (class 1255 OID 17129)
-- Name: report_top_products(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.report_top_products(p_limit integer DEFAULT 10) RETURNS TABLE(product_id uuid, product_name character varying, total_requests bigint, total_revenue numeric)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        pr.product_id,
        pr.producto_nombre,
        COUNT(*) as total_requests,
        COALESCE(SUM(pay.monto_total) FILTER (WHERE pay.status = 'completado'), 0) as total_revenue
    FROM purchase_requests pr
    LEFT JOIN payments pay ON pay.request_id = pr.id
    WHERE pr.deleted_at IS NULL
      AND pr.product_id IS NOT NULL
    GROUP BY pr.product_id, pr.producto_nombre
    ORDER BY total_requests DESC
    LIMIT p_limit;
END;
$$;


ALTER FUNCTION public.report_top_products(p_limit integer) OWNER TO postgres;

--
-- TOC entry 5479 (class 0 OID 0)
-- Dependencies: 324
-- Name: FUNCTION report_top_products(p_limit integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.report_top_products(p_limit integer) IS 'Muestra los productos más solicitados con sus ingresos totales.
Ejemplo: SELECT * FROM report_top_products(5);';


--
-- TOC entry 365 (class 1255 OID 17122)
-- Name: update_material_stock(uuid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_material_stock(p_material_id uuid, p_cantidad_delta integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE materials
    SET stock_actual = stock_actual + p_cantidad_delta
    WHERE id = p_material_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Material no encontrado: %', p_material_id;
    END IF;
END;
$$;


ALTER FUNCTION public.update_material_stock(p_material_id uuid, p_cantidad_delta integer) OWNER TO postgres;

--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 365
-- Name: FUNCTION update_material_stock(p_material_id uuid, p_cantidad_delta integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.update_material_stock(p_material_id uuid, p_cantidad_delta integer) IS 'Actualiza el stock de un material.
cantidad_delta puede ser positivo (agregar) o negativo (descontar).
Ejemplo: update_material_stock(id, -5) descuenta 5 unidades.';


--
-- TOC entry 265 (class 1255 OID 16672)
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

--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 265
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Trigger function para actualizar automáticamente el campo updated_at';


--
-- TOC entry 351 (class 1255 OID 17126)
-- Name: validate_material_stock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_material_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.stock_actual < 0 THEN
        RAISE EXCEPTION 'No se puede tener stock negativo para material %', NEW.nombre;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_material_stock() OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 17124)
-- Name: validate_single_active_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_single_active_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF NEW.is_active = TRUE THEN
        SELECT COUNT(*) INTO v_count
        FROM product_prices
        WHERE product_id = NEW.product_id
          AND is_active = TRUE
          AND id != NEW.id;

        IF v_count > 0 THEN
            RAISE EXCEPTION 'Ya existe un precio activo para este producto';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_single_active_price() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 16675)
-- Name: verify_password(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.verify_password(password text, hashed text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN hashed = crypt(password, hashed);
END;
$$;


ALTER FUNCTION public.verify_password(password text, hashed text) OWNER TO postgres;

--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 267
-- Name: FUNCTION verify_password(password text, hashed text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.verify_password(password text, hashed text) IS 'Verifica si una contraseña coincide con su hash bcrypt';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 16866)
-- Name: budgets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budgets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    request_id uuid NOT NULL,
    vendor_id uuid,
    cliente_nombre character varying(255) NOT NULL,
    cliente_email public.email NOT NULL,
    cliente_telefono public.phone_pe,
    nombre character varying(255) NOT NULL,
    descripcion text,
    status public.budget_status DEFAULT 'borrador'::public.budget_status,
    mano_de_obra public.positive_decimal DEFAULT 0,
    margen_ganancia public.percentage DEFAULT 30,
    servicio_explicacion jsonb,
    adelanto jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    sent_at timestamp without time zone,
    accepted_at timestamp without time zone,
    rejected_at timestamp without time zone
);


ALTER TABLE public.budgets OWNER TO postgres;

--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE budgets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.budgets IS 'Presupuestos creados por vendedores en respuesta a solicitudes.
Contiene items de presupuesto (budget_items) que pueden ser:
- product_prices (maqueta completa)
- complete_kits (kit de materiales)
- materials (materiales individuales)';


--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN budgets.servicio_explicacion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budgets.servicio_explicacion IS 'JSONB: {incluido, tipoEvento, cantidadPersonas, duracion, precio}';


--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN budgets.adelanto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budgets.adelanto IS 'JSONB: {requerido, monto, porcentaje, pagado}';


--
-- TOC entry 238 (class 1259 OID 16933)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    request_id uuid NOT NULL,
    budget_id uuid,
    cliente_nombre character varying(255) NOT NULL,
    cliente_email public.email NOT NULL,
    cliente_telefono public.phone_pe,
    producto_nombre character varying(255) NOT NULL,
    monto_total public.positive_decimal NOT NULL,
    status public.payment_status DEFAULT 'pendiente-adelanto'::public.payment_status,
    entregado boolean DEFAULT false,
    fecha_entrega timestamp without time zone,
    adelanto jsonb NOT NULL,
    pago_final jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    payment_method character varying(30),
    operation_code character varying(100)
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.payments IS 'Registro de pagos con adelanto y pago final.
Soporta evidencias fotográficas en base64 (stored in JSONB).';


--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN payments.adelanto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.adelanto IS 'JSONB: {monto, pagado, fechaPago, evidencia(base64)}';


--
-- TOC entry 5488 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN payments.pago_final; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.payments.pago_final IS 'JSONB: {monto, pagado, fechaPago, evidencia(base64)}';


--
-- TOC entry 229 (class 1259 OID 16743)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_id uuid,
    title character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    description text NOT NULL,
    image_url text,
    display_price public.positive_decimal DEFAULT 0,
    school_grade character varying(50),
    occasion character varying(100),
    materials text[],
    is_featured boolean DEFAULT false,
    is_active boolean DEFAULT true,
    view_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone,
    production_time_minutes integer,
    estimated_material_cost numeric(10,2),
    CONSTRAINT check_slug_format CHECK (((slug)::text ~ '^[a-z0-9-]+$'::text))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 5489 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.products IS 'Catálogo de maquetas educativas disponibles. Base del sistema de solicitudes.';


--
-- TOC entry 5490 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN products.display_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.display_price IS 'Precio de referencia mostrado en catálogo. El precio real viene de product_prices o budgets.';


--
-- TOC entry 5491 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN products.materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.materials IS 'Array de nombres de materiales sugeridos para esta maqueta (solo referencia visual)';


--
-- TOC entry 5492 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN products.view_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.view_count IS 'Contador de visualizaciones para analytics y productos populares';


--
-- TOC entry 234 (class 1259 OID 16835)
-- Name: purchase_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_requests (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    product_id uuid,
    cliente_nombre character varying(255) NOT NULL,
    cliente_email public.email NOT NULL,
    cliente_telefono public.phone_pe,
    producto_nombre character varying(255) NOT NULL,
    mensaje text,
    status public.purchase_status DEFAULT 'pendiente'::public.purchase_status,
    is_kit boolean DEFAULT false,
    is_custom boolean DEFAULT false,
    solicitar_explicacion boolean DEFAULT false,
    tipo_explicacion public.explanation_type,
    tipo_evento character varying(255),
    cantidad_personas public.positive_integer,
    budget_id uuid,
    budget_created boolean DEFAULT false,
    kits_maquetas jsonb,
    kits_personalizados jsonb,
    materiales_personales jsonb,
    materiales_seleccionados text[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE public.purchase_requests OWNER TO postgres;

--
-- TOC entry 5493 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE purchase_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.purchase_requests IS 'Solicitudes de compra de clientes. Núcleo del sistema de negocio.
Una solicitud puede ser: compra normal, kit personalizado, o personalización total.
El vendedor la revisa y crea un presupuesto asociado.';


--
-- TOC entry 5494 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN purchase_requests.is_kit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.is_kit IS 'TRUE si el cliente pidió múltiples maquetas en kit';


--
-- TOC entry 5495 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN purchase_requests.is_custom; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.is_custom IS 'TRUE si el cliente pidió personalización con materiales específicos';


--
-- TOC entry 5496 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN purchase_requests.kits_maquetas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.kits_maquetas IS 'JSONB con array de kits: [{productId, productName, cantidad}]';


--
-- TOC entry 5497 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN purchase_requests.kits_personalizados; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.kits_personalizados IS 'JSONB con array de materiales personalizados: [{materialId, cantidad, costo}]';


--
-- TOC entry 5498 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN purchase_requests.materiales_personales; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.purchase_requests.materiales_personales IS 'JSONB con array de materiales individuales del cliente';


--
-- TOC entry 240 (class 1259 OID 17081)
-- Name: active_purchase_requests; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.active_purchase_requests AS
 SELECT pr.id,
    pr.user_id,
    pr.product_id,
    pr.cliente_nombre,
    pr.cliente_email,
    pr.cliente_telefono,
    pr.producto_nombre,
    pr.mensaje,
    pr.status,
    pr.is_kit,
    pr.is_custom,
    pr.solicitar_explicacion,
    pr.tipo_explicacion,
    pr.tipo_evento,
    pr.cantidad_personas,
    pr.budget_id,
    pr.budget_created,
    pr.kits_maquetas,
    pr.kits_personalizados,
    pr.materiales_personales,
    pr.materiales_seleccionados,
    pr.created_at,
    pr.updated_at,
    pr.deleted_at,
    p.title AS product_title,
    p.image_url AS product_image,
    b.id AS current_budget_id,
    b.status AS budget_status,
    pay.id AS payment_id,
    pay.status AS payment_status,
    pay.entregado AS payment_delivered
   FROM (((public.purchase_requests pr
     LEFT JOIN public.products p ON ((p.id = pr.product_id)))
     LEFT JOIN public.budgets b ON ((b.request_id = pr.id)))
     LEFT JOIN public.payments pay ON ((pay.request_id = pr.id)))
  WHERE ((pr.deleted_at IS NULL) AND (pr.status <> 'completado'::public.purchase_status))
  ORDER BY pr.created_at DESC;


ALTER VIEW public.active_purchase_requests OWNER TO postgres;

--
-- TOC entry 5499 (class 0 OID 0)
-- Dependencies: 240
-- Name: VIEW active_purchase_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.active_purchase_requests IS 'Vista para mostrar solicitudes activas en dashboard del vendedor';


--
-- TOC entry 236 (class 1259 OID 16893)
-- Name: budget_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budget_items (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    budget_id uuid NOT NULL,
    material_id uuid,
    cantidad public.positive_integer DEFAULT 1 NOT NULL,
    is_kit_completo boolean DEFAULT false,
    kit_completo_id character varying(255),
    kit_precio public.positive_decimal,
    costo_unitario public.positive_decimal NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.budget_items OWNER TO postgres;

--
-- TOC entry 5500 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE budget_items; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.budget_items IS 'Items individuales de un presupuesto. Cada item puede ser:
1. Material individual (material_id + cantidad)
2. Kit completo (is_kit_completo=true, kit_completo_id con prefijo "kit-")
3. Precio maqueta (is_kit_completo=true, kit_completo_id con prefijo "maqueta-")

El sistema identifica el tipo por el prefijo del kit_completo_id.';


--
-- TOC entry 5501 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN budget_items.costo_unitario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.budget_items.costo_unitario IS 'Snapshot del costo al momento de crear el presupuesto (para histórico)';


--
-- TOC entry 228 (class 1259 OID 16724)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    icon character varying(50),
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT check_slug_format CHECK (((slug)::text ~ '^[a-z0-9-]+$'::text))
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 5502 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.categories IS 'Categorías de productos (ciencia, geografía, historia, etc.)';


--
-- TOC entry 5503 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN categories.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.categories.slug IS 'Slug URL-friendly generado automáticamente. Usar generate_slug() si se cambia el nombre.';


--
-- TOC entry 231 (class 1259 OID 16793)
-- Name: complete_kits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complete_kits (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product_id uuid NOT NULL,
    product_name character varying(255) NOT NULL,
    descripcion text,
    precio_total public.positive_decimal NOT NULL,
    incluye_instrucciones boolean DEFAULT true,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.complete_kits OWNER TO postgres;

--
-- TOC entry 5504 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE complete_kits; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.complete_kits IS 'Kits de materiales completos para que el cliente arme la maqueta.
Diferente a product_prices: el kit son SOLO materiales, el cliente arma.
Usado en solicitudes tipo "kit personalizado" con múltiples maquetas.';


--
-- TOC entry 230 (class 1259 OID 16770)
-- Name: product_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_prices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product_id uuid NOT NULL,
    product_name character varying(255) NOT NULL,
    precio_completa public.positive_decimal NOT NULL,
    descripcion text,
    incluye_armado boolean DEFAULT true,
    incluye_pintura boolean DEFAULT true,
    tiempo_entrega_dias public.positive_integer DEFAULT 7,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.product_prices OWNER TO postgres;

--
-- TOC entry 5505 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE product_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product_prices IS 'Precios de maquetas completamente terminadas (armadas y pintadas).
Se usa cuando el cliente solicita una maqueta del catálogo normal.
Cuando existe precio_completa, NO se calculan materiales individuales ni mano de obra.';


--
-- TOC entry 5506 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN product_prices.precio_completa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_prices.precio_completa IS 'Precio fijo de la maqueta terminada. Ya incluye materiales, mano de obra y margen.';


--
-- TOC entry 245 (class 1259 OID 17149)
-- Name: catalog_products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.catalog_products AS
 SELECT p.id,
    p.title,
    p.slug,
    p.description,
    p.image_url,
    p.display_price,
    p.school_grade,
    p.occasion,
    p.materials,
    p.is_featured,
    p.view_count,
    c.id AS category_id,
    c.name AS category_name,
    c.slug AS category_slug,
    pp.id AS precio_maqueta_id,
    pp.precio_completa,
    pp.descripcion AS precio_maqueta_descripcion,
    pp.tiempo_entrega_dias,
    ck.id AS kit_completo_id,
    ck.precio_total AS kit_precio_total,
    ck.descripcion AS kit_descripcion,
        CASE
            WHEN ((pp.id IS NOT NULL) OR (ck.id IS NOT NULL)) THEN true
            ELSE false
        END AS tiene_precio_definido,
    ( SELECT count(*) AS count
           FROM public.purchase_requests pr
          WHERE ((pr.product_id = p.id) AND (pr.deleted_at IS NULL))) AS total_requests
   FROM (((public.products p
     LEFT JOIN public.categories c ON ((c.id = p.category_id)))
     LEFT JOIN public.product_prices pp ON (((pp.product_id = p.id) AND (pp.is_active = true))))
     LEFT JOIN public.complete_kits ck ON (((ck.product_id = p.id) AND (ck.is_active = true))))
  WHERE ((p.deleted_at IS NULL) AND (p.is_active = true))
  ORDER BY p.is_featured DESC, p.view_count DESC, p.created_at DESC;


ALTER VIEW public.catalog_products OWNER TO postgres;

--
-- TOC entry 5507 (class 0 OID 0)
-- Dependencies: 245
-- Name: VIEW catalog_products; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.catalog_products IS 'Vista para mostrar productos en el catálogo con precios y disponibilidad.
Incluye información de categoría, precios y estadísticas.';


--
-- TOC entry 237 (class 1259 OID 16916)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    request_id uuid NOT NULL,
    sender_type public.message_sender_type NOT NULL,
    sender_id uuid,
    message text NOT NULL,
    budget_attached boolean DEFAULT false,
    budget_total public.positive_decimal,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 5508 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE messages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.messages IS 'Sistema de mensajería entre cliente y vendedor dentro de una solicitud.
El vendedor puede adjuntar presupuestos en los mensajes.';


--
-- TOC entry 5509 (class 0 OID 0)
-- Dependencies: 237
-- Name: COLUMN messages.sender_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.messages.sender_id IS 'ID del usuario o vendedor que envió el mensaje';


--
-- TOC entry 244 (class 1259 OID 17144)
-- Name: client_dashboard_requests; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.client_dashboard_requests AS
 SELECT pr.id AS request_id,
    pr.producto_nombre,
    pr.mensaje,
    pr.status AS request_status,
    pr.created_at AS request_created_at,
    pr.updated_at AS request_updated_at,
    p.id AS product_id,
    p.title AS product_title,
    p.image_url AS product_image,
    b.id AS budget_id,
    b.status AS budget_status,
    pay.id AS payment_id,
    pay.status AS payment_status,
    pay.monto_total,
    ( SELECT jsonb_build_object('id', m.id, 'message', m.message, 'created_at', m.created_at, 'budget_attached', m.budget_attached, 'budget_total', m.budget_total) AS jsonb_build_object
           FROM public.messages m
          WHERE ((m.request_id = pr.id) AND (m.sender_type = 'vendor'::public.message_sender_type))
          ORDER BY m.created_at DESC
         LIMIT 1) AS last_vendor_message,
    ( SELECT count(*) AS count
           FROM public.messages m
          WHERE (m.request_id = pr.id)) AS messages_count
   FROM (((public.purchase_requests pr
     LEFT JOIN public.products p ON ((p.id = pr.product_id)))
     LEFT JOIN public.budgets b ON ((b.request_id = pr.id)))
     LEFT JOIN public.payments pay ON ((pay.request_id = pr.id)))
  WHERE ((pr.deleted_at IS NULL) AND (pr.status <> 'completado'::public.purchase_status))
  ORDER BY pr.created_at DESC;


ALTER VIEW public.client_dashboard_requests OWNER TO postgres;

--
-- TOC entry 5510 (class 0 OID 0)
-- Dependencies: 244
-- Name: VIEW client_dashboard_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.client_dashboard_requests IS 'Vista para el dashboard "Mis Solicitudes" del cliente.
Excluye solicitudes completadas.';


--
-- TOC entry 250 (class 1259 OID 17206)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(150) NOT NULL,
    role character varying(100),
    phone character varying(30),
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17058)
-- Name: file_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_uploads (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    uploaded_by_type character varying(50) NOT NULL,
    uploaded_by_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(100) NOT NULL,
    file_size integer NOT NULL,
    storage_path text NOT NULL,
    related_table character varying(100),
    related_id uuid,
    is_temporary boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone
);


ALTER TABLE public.file_uploads OWNER TO postgres;

--
-- TOC entry 5511 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE file_uploads; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.file_uploads IS 'Registro de archivos subidos al sistema (imágenes de productos, evidencias de pago, etc.)
En producción, storage_path apuntaría a S3, Cloudinary, etc.';


--
-- TOC entry 249 (class 1259 OID 17194)
-- Name: institutions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institutions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(150) NOT NULL,
    institution_type character varying(50) NOT NULL,
    district character varying(100),
    province character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.institutions OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17229)
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    material_id uuid NOT NULL,
    movement_type character varying(30) NOT NULL,
    quantity numeric(10,2) NOT NULL,
    reason text,
    employee_id uuid,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.inventory_movements OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17215)
-- Name: material_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    material_id uuid NOT NULL,
    supplier_name character varying(150),
    quantity numeric(10,2) NOT NULL,
    unit_cost numeric(10,2),
    entry_date timestamp without time zone DEFAULT now(),
    notes text
);


ALTER TABLE public.material_batches OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16811)
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    categoria public.material_category NOT NULL,
    unidad character varying(50) NOT NULL,
    costo_por_unidad public.positive_decimal NOT NULL,
    stock_actual public.positive_integer DEFAULT 0,
    stock_minimo public.positive_integer DEFAULT 10,
    proveedor character varying(255),
    descripcion text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    minimum_stock numeric(10,2) DEFAULT 0,
    unit_measure character varying(50),
    material_type character varying(100),
    CONSTRAINT check_slug_format CHECK (((slug)::text ~ '^[a-z0-9-]+$'::text))
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- TOC entry 5512 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.materials IS 'Inventario de materiales individuales usados por el vendedor para crear presupuestos personalizados.
Se usa cuando el cliente pide personalización o el vendedor calcula costos manualmente.';


--
-- TOC entry 5513 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN materials.stock_actual; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.stock_actual IS 'Stock disponible actual. Se podría implementar descuento automático al completar ventas.';


--
-- TOC entry 233 (class 1259 OID 16831)
-- Name: materials_stock_status; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.materials_stock_status AS
 SELECT id,
    nombre,
    stock_actual,
    stock_minimo,
        CASE
            WHEN ((stock_actual)::integer = 0) THEN 'agotado'::public.stock_level
            WHEN ((stock_actual)::integer <= (stock_minimo)::integer) THEN 'stock-bajo'::public.stock_level
            ELSE 'disponible'::public.stock_level
        END AS nivel_stock
   FROM public.materials m
  WHERE (is_active = true);


ALTER VIEW public.materials_stock_status OWNER TO postgres;

--
-- TOC entry 5514 (class 0 OID 0)
-- Dependencies: 233
-- Name: VIEW materials_stock_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.materials_stock_status IS 'Vista helper para mostrar alertas de stock bajo en la UI';


--
-- TOC entry 248 (class 1259 OID 17180)
-- Name: mv_material_popularity; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_material_popularity AS
 SELECT m.id AS material_id,
    m.nombre AS material_name,
    m.categoria,
    m.costo_por_unidad,
    m.stock_actual,
    count(DISTINCT bi.budget_id) AS times_used_in_budgets,
    COALESCE(sum((bi.cantidad)::integer), (0)::bigint) AS total_quantity_used,
    COALESCE(sum(((bi.cantidad)::numeric * (bi.costo_unitario)::numeric)), (0)::numeric) AS total_value_used,
    count(DISTINCT bi.budget_id) FILTER (WHERE (EXISTS ( SELECT 1
           FROM (public.budgets b
             JOIN public.purchase_requests pr ON ((pr.id = b.request_id)))
          WHERE ((b.id = bi.budget_id) AND (pr.status = 'completado'::public.purchase_status))))) AS times_used_completed,
    now() AS last_refreshed
   FROM (public.materials m
     LEFT JOIN public.budget_items bi ON (((bi.material_id = m.id) AND (bi.is_kit_completo = false))))
  WHERE (m.is_active = true)
  GROUP BY m.id, m.nombre, m.categoria, m.costo_por_unidad, m.stock_actual
  ORDER BY (count(DISTINCT bi.budget_id)) DESC
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_material_popularity OWNER TO postgres;

--
-- TOC entry 5515 (class 0 OID 0)
-- Dependencies: 248
-- Name: MATERIALIZED VIEW mv_material_popularity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON MATERIALIZED VIEW public.mv_material_popularity IS 'Vista materializada de materiales más usados.
Útil para gestión de inventario y compras.';


--
-- TOC entry 247 (class 1259 OID 17167)
-- Name: mv_monthly_statistics; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_monthly_statistics AS
 SELECT date_trunc('month'::text, pr.created_at) AS month,
    count(DISTINCT pr.id) AS total_requests,
    count(DISTINCT pr.id) FILTER (WHERE (pr.status = 'pendiente'::public.purchase_status)) AS pending_requests,
    count(DISTINCT pr.id) FILTER (WHERE (pr.status = 'procesando'::public.purchase_status)) AS processing_requests,
    count(DISTINCT pr.id) FILTER (WHERE (pr.status = 'completado'::public.purchase_status)) AS completed_requests,
    count(DISTINCT pr.id) FILTER (WHERE (pr.status = 'cancelado'::public.purchase_status)) AS cancelled_requests,
    count(DISTINCT b.id) AS total_budgets,
    count(DISTINCT b.id) FILTER (WHERE (b.status = 'enviado'::public.budget_status)) AS sent_budgets,
    count(DISTINCT b.id) FILTER (WHERE (b.status = 'aceptado'::public.budget_status)) AS accepted_budgets,
    count(DISTINCT pay.id) AS total_payments,
    COALESCE(sum((pay.monto_total)::numeric) FILTER (WHERE (pay.status = 'completado'::public.payment_status)), (0)::numeric) AS total_revenue,
    COALESCE(avg((pay.monto_total)::numeric) FILTER (WHERE (pay.status = 'completado'::public.payment_status)), (0)::numeric) AS avg_order_value,
    count(DISTINCT pr.user_id) AS unique_customers,
    now() AS last_refreshed
   FROM ((public.purchase_requests pr
     LEFT JOIN public.budgets b ON ((b.request_id = pr.id)))
     LEFT JOIN public.payments pay ON ((pay.request_id = pr.id)))
  WHERE (pr.deleted_at IS NULL)
  GROUP BY (date_trunc('month'::text, pr.created_at))
  ORDER BY (date_trunc('month'::text, pr.created_at)) DESC
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_monthly_statistics OWNER TO postgres;

--
-- TOC entry 5516 (class 0 OID 0)
-- Dependencies: 247
-- Name: MATERIALIZED VIEW mv_monthly_statistics; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON MATERIALIZED VIEW public.mv_monthly_statistics IS 'Vista materializada con estadísticas mensuales del negocio.
Útil para dashboards y reportes gerenciales.';


--
-- TOC entry 246 (class 1259 OID 17154)
-- Name: mv_product_statistics; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_product_statistics AS
 SELECT p.id AS product_id,
    p.title AS product_name,
    p.category_id,
    c.name AS category_name,
    count(DISTINCT pr.id) AS total_requests,
    count(DISTINCT pr.id) FILTER (WHERE (pr.status = 'completado'::public.purchase_status)) AS completed_requests,
    COALESCE(sum((pay.monto_total)::numeric) FILTER (WHERE (pay.status = 'completado'::public.payment_status)), (0)::numeric) AS total_revenue,
    COALESCE(avg((pay.monto_total)::numeric) FILTER (WHERE (pay.status = 'completado'::public.payment_status)), (0)::numeric) AS avg_revenue,
    0 AS avg_rating,
    0 AS total_ratings,
    min(pr.created_at) AS first_request_date,
    max(pr.created_at) AS last_request_date,
    now() AS last_refreshed
   FROM (((public.products p
     LEFT JOIN public.categories c ON ((c.id = p.category_id)))
     LEFT JOIN public.purchase_requests pr ON (((pr.product_id = p.id) AND (pr.deleted_at IS NULL))))
     LEFT JOIN public.payments pay ON ((pay.request_id = pr.id)))
  WHERE (p.deleted_at IS NULL)
  GROUP BY p.id, p.title, p.category_id, c.name
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_product_statistics OWNER TO postgres;

--
-- TOC entry 5517 (class 0 OID 0)
-- Dependencies: 246
-- Name: MATERIALIZED VIEW mv_product_statistics; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON MATERIALIZED VIEW public.mv_product_statistics IS 'Vista materializada con estadísticas de productos.
Refrescar periódicamente: REFRESH MATERIALIZED VIEW CONCURRENTLY mv_product_statistics;';


--
-- TOC entry 255 (class 1259 OID 17291)
-- Name: production_costs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production_costs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    production_id uuid NOT NULL,
    material_cost numeric(10,2),
    loss_cost numeric(10,2),
    labor_cost numeric(10,2),
    total_cost numeric(10,2),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.production_costs OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 17272)
-- Name: production_losses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production_losses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    production_id uuid NOT NULL,
    lost_quantity integer NOT NULL,
    reason character varying(100),
    description text,
    reported_by uuid,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.production_losses OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17248)
-- Name: productions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    employee_id uuid,
    batch_id uuid,
    expected_pieces integer NOT NULL,
    produced_pieces integer NOT NULL,
    production_date timestamp without time zone DEFAULT now(),
    notes text
);


ALTER TABLE public.productions OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17086)
-- Name: products_with_pricing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.products_with_pricing AS
 SELECT p.id,
    p.category_id,
    p.title,
    p.slug,
    p.description,
    p.image_url,
    p.display_price,
    p.school_grade,
    p.occasion,
    p.materials,
    p.is_featured,
    p.is_active,
    p.view_count,
    p.created_at,
    p.updated_at,
    p.deleted_at,
    pp.precio_completa,
    pp.id AS precio_maqueta_id,
    ck.precio_total AS kit_precio,
    ck.id AS kit_completo_id
   FROM ((public.products p
     LEFT JOIN public.product_prices pp ON (((pp.product_id = p.id) AND (pp.is_active = true))))
     LEFT JOIN public.complete_kits ck ON (((ck.product_id = p.id) AND (ck.is_active = true))))
  WHERE (p.deleted_at IS NULL);


ALTER VIEW public.products_with_pricing OWNER TO postgres;

--
-- TOC entry 5518 (class 0 OID 0)
-- Dependencies: 241
-- Name: VIEW products_with_pricing; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.products_with_pricing IS 'Vista para mostrar productos con sus precios y kits en el catálogo';


--
-- TOC entry 257 (class 1259 OID 17315)
-- Name: sale_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sale_details (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sale_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2),
    subtotal numeric(10,2)
);


ALTER TABLE public.sale_details OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 17303)
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    total numeric(10,2),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16686)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email public.email NOT NULL,
    password_hash text NOT NULL,
    phone public.phone_pe,
    role public.user_role DEFAULT 'client'::public.user_role NOT NULL,
    email_verified boolean DEFAULT false,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone,
    institution_id uuid,
    CONSTRAINT check_user_role CHECK ((role = ANY (ARRAY['client'::public.user_role, 'admin'::public.user_role])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5519 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Clientes del sistema que pueden realizar solicitudes de compra';


--
-- TOC entry 5520 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN users.password_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.password_hash IS 'Password hasheado con bcrypt usando pgcrypto. Usar hash_password() para crear.';


--
-- TOC entry 5521 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN users.deleted_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.deleted_at IS 'Soft delete: si tiene valor, el usuario está eliminado lógicamente';


--
-- TOC entry 242 (class 1259 OID 17134)
-- Name: vendor_dashboard_requests; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vendor_dashboard_requests AS
 SELECT pr.id AS request_id,
    pr.cliente_nombre,
    pr.cliente_email,
    pr.cliente_telefono,
    pr.producto_nombre,
    pr.mensaje,
    pr.status AS request_status,
    pr.is_kit,
    pr.is_custom,
    pr.solicitar_explicacion,
    pr.tipo_explicacion,
    pr.tipo_evento,
    pr.cantidad_personas,
    pr.budget_created,
    pr.created_at AS request_created_at,
    pr.updated_at AS request_updated_at,
    p.id AS product_id,
    p.title AS product_title,
    p.image_url AS product_image,
    p.school_grade,
    p.occasion,
    b.id AS budget_id,
    b.nombre AS budget_nombre,
    b.status AS budget_status,
    b.created_at AS budget_created_at,
    pay.id AS payment_id,
    pay.status AS payment_status,
    pay.monto_total AS payment_monto_total,
    pay.entregado AS payment_entregado,
    ( SELECT jsonb_build_object('id', m.id, 'sender_type', m.sender_type, 'message', m.message, 'created_at', m.created_at, 'budget_attached', m.budget_attached) AS jsonb_build_object
           FROM public.messages m
          WHERE (m.request_id = pr.id)
          ORDER BY m.created_at DESC
         LIMIT 1) AS last_message,
    ( SELECT count(*) AS count
           FROM public.messages m
          WHERE ((m.request_id = pr.id) AND (m.sender_type = 'client'::public.message_sender_type))) AS unread_messages_count
   FROM (((public.purchase_requests pr
     LEFT JOIN public.products p ON ((p.id = pr.product_id)))
     LEFT JOIN public.budgets b ON ((b.request_id = pr.id)))
     LEFT JOIN public.payments pay ON ((pay.request_id = pr.id)))
  WHERE ((pr.deleted_at IS NULL) AND (pr.status = ANY (ARRAY['pendiente'::public.purchase_status, 'procesando'::public.purchase_status])))
  ORDER BY pr.created_at DESC;


ALTER VIEW public.vendor_dashboard_requests OWNER TO postgres;

--
-- TOC entry 5522 (class 0 OID 0)
-- Dependencies: 242
-- Name: VIEW vendor_dashboard_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vendor_dashboard_requests IS 'Vista consolidada para el dashboard del vendedor.
Incluye solicitudes activas con presupuestos, pagos y último mensaje.';


--
-- TOC entry 243 (class 1259 OID 17139)
-- Name: vendor_pending_payments; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vendor_pending_payments AS
 SELECT pay.id AS payment_id,
    pay.request_id,
    pay.cliente_nombre,
    pay.cliente_email,
    pay.cliente_telefono,
    pay.producto_nombre,
    pay.monto_total,
    pay.status AS payment_status,
    pay.entregado,
    pay.created_at AS payment_created_at,
    ((pay.adelanto ->> 'monto'::text))::numeric(10,2) AS adelanto_monto,
    ((pay.adelanto ->> 'pagado'::text))::boolean AS adelanto_pagado,
    ((pay.adelanto ->> 'fechaPago'::text))::timestamp without time zone AS adelanto_fecha_pago,
    ((pay.pago_final ->> 'monto'::text))::numeric(10,2) AS pago_final_monto,
    ((pay.pago_final ->> 'pagado'::text))::boolean AS pago_final_pagado,
    ((pay.pago_final ->> 'fechaPago'::text))::timestamp without time zone AS pago_final_fecha_pago,
    pr.producto_nombre AS request_producto,
    pr.created_at AS request_created_at
   FROM (public.payments pay
     JOIN public.purchase_requests pr ON ((pr.id = pay.request_id)))
  WHERE (pay.entregado = false)
  ORDER BY
        CASE
            WHEN (pay.status = 'pendiente-adelanto'::public.payment_status) THEN 1
            WHEN (pay.status = 'adelanto-pagado'::public.payment_status) THEN 2
            ELSE 3
        END, pay.created_at DESC;


ALTER VIEW public.vendor_pending_payments OWNER TO postgres;

--
-- TOC entry 5523 (class 0 OID 0)
-- Dependencies: 243
-- Name: VIEW vendor_pending_payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vendor_pending_payments IS 'Vista de pagos pendientes de entrega para el vendedor.
Ordenados por prioridad de estado.';


--
-- TOC entry 227 (class 1259 OID 16705)
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendors (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email public.email NOT NULL,
    password_hash text NOT NULL,
    phone public.phone_pe,
    is_active boolean DEFAULT true,
    can_manage_materials boolean DEFAULT true,
    can_create_budgets boolean DEFAULT true,
    can_view_all_requests boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone,
    CONSTRAINT check_vendor_permissions CHECK ((can_manage_materials OR can_create_budgets OR can_view_all_requests))
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- TOC entry 5524 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE vendors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.vendors IS 'Vendedores/administradores que gestionan solicitudes y crean presupuestos';


--
-- TOC entry 5525 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN vendors.can_manage_materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vendors.can_manage_materials IS 'Permiso para agregar/editar materiales, precios de maquetas y kits completos';


--
-- TOC entry 5218 (class 2606 OID 16903)
-- Name: budget_items budget_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5210 (class 2606 OID 16878)
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- TOC entry 5156 (class 2606 OID 16738)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 5158 (class 2606 OID 16736)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 5160 (class 2606 OID 16740)
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- TOC entry 5184 (class 2606 OID 16804)
-- Name: complete_kits complete_kits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_kits
    ADD CONSTRAINT complete_kits_pkey PRIMARY KEY (id);


--
-- TOC entry 5247 (class 2606 OID 17213)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- TOC entry 5237 (class 2606 OID 17067)
-- Name: file_uploads file_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_uploads
    ADD CONSTRAINT file_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 5245 (class 2606 OID 17200)
-- Name: institutions institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- TOC entry 5251 (class 2606 OID 17237)
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- TOC entry 5249 (class 2606 OID 17223)
-- Name: material_batches material_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_batches
    ADD CONSTRAINT material_batches_pkey PRIMARY KEY (id);


--
-- TOC entry 5194 (class 2606 OID 16824)
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- TOC entry 5196 (class 2606 OID 16826)
-- Name: materials materials_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_slug_key UNIQUE (slug);


--
-- TOC entry 5226 (class 2606 OID 16925)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 5235 (class 2606 OID 16944)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 5180 (class 2606 OID 16783)
-- Name: product_prices product_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices
    ADD CONSTRAINT product_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 5257 (class 2606 OID 17297)
-- Name: production_costs production_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_costs
    ADD CONSTRAINT production_costs_pkey PRIMARY KEY (id);


--
-- TOC entry 5255 (class 2606 OID 17280)
-- Name: production_losses production_losses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_losses
    ADD CONSTRAINT production_losses_pkey PRIMARY KEY (id);


--
-- TOC entry 5253 (class 2606 OID 17256)
-- Name: productions productions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productions
    ADD CONSTRAINT productions_pkey PRIMARY KEY (id);


--
-- TOC entry 5173 (class 2606 OID 16757)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 5175 (class 2606 OID 16759)
-- Name: products products_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_slug_key UNIQUE (slug);


--
-- TOC entry 5208 (class 2606 OID 16849)
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5261 (class 2606 OID 17320)
-- Name: sale_details sale_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT sale_details_pkey PRIMARY KEY (id);


--
-- TOC entry 5259 (class 2606 OID 17309)
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- TOC entry 5182 (class 2606 OID 16785)
-- Name: product_prices unique_active_price_per_product; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices
    ADD CONSTRAINT unique_active_price_per_product UNIQUE NULLS NOT DISTINCT (product_id, is_active);


--
-- TOC entry 5526 (class 0 OID 0)
-- Dependencies: 5182
-- Name: CONSTRAINT unique_active_price_per_product ON product_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT unique_active_price_per_product ON public.product_prices IS 'Solo puede haber un precio activo por producto a la vez';


--
-- TOC entry 5146 (class 2606 OID 16701)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5148 (class 2606 OID 16699)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5152 (class 2606 OID 16721)
-- Name: vendors vendors_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_email_key UNIQUE (email);


--
-- TOC entry 5154 (class 2606 OID 16719)
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- TOC entry 5219 (class 1259 OID 16914)
-- Name: idx_budget_items_budget; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budget_items_budget ON public.budget_items USING btree (budget_id);


--
-- TOC entry 5220 (class 1259 OID 16915)
-- Name: idx_budget_items_material; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budget_items_material ON public.budget_items USING btree (material_id);


--
-- TOC entry 5221 (class 1259 OID 17114)
-- Name: idx_budget_items_material_usage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budget_items_material_usage ON public.budget_items USING btree (material_id, cantidad);


--
-- TOC entry 5527 (class 0 OID 0)
-- Dependencies: 5221
-- Name: INDEX idx_budget_items_material_usage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_budget_items_material_usage IS 'Permite analizar qué materiales se usan más frecuentemente';


--
-- TOC entry 5211 (class 1259 OID 16892)
-- Name: idx_budgets_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_created ON public.budgets USING btree (created_at DESC);


--
-- TOC entry 5212 (class 1259 OID 17104)
-- Name: idx_budgets_draft; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_draft ON public.budgets USING btree (request_id, created_at DESC) WHERE (status = 'borrador'::public.budget_status);


--
-- TOC entry 5528 (class 0 OID 0)
-- Dependencies: 5212
-- Name: INDEX idx_budgets_draft; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_budgets_draft IS 'Optimiza recuperación de presupuestos en progreso';


--
-- TOC entry 5213 (class 1259 OID 16889)
-- Name: idx_budgets_request; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_request ON public.budgets USING btree (request_id);


--
-- TOC entry 5214 (class 1259 OID 16891)
-- Name: idx_budgets_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_status ON public.budgets USING btree (status);


--
-- TOC entry 5215 (class 1259 OID 16890)
-- Name: idx_budgets_vendor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_vendor ON public.budgets USING btree (vendor_id);


--
-- TOC entry 5216 (class 1259 OID 17093)
-- Name: idx_budgets_vendor_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_budgets_vendor_status ON public.budgets USING btree (vendor_id, status, created_at DESC);


--
-- TOC entry 5529 (class 0 OID 0)
-- Dependencies: 5216
-- Name: INDEX idx_budgets_vendor_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_budgets_vendor_status IS 'Optimiza dashboard del vendedor mostrando presupuestos por estado';


--
-- TOC entry 5161 (class 1259 OID 16741)
-- Name: idx_categories_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_active ON public.categories USING btree (is_active, display_order);


--
-- TOC entry 5162 (class 1259 OID 16742)
-- Name: idx_categories_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categories_slug ON public.categories USING btree (slug) WHERE (is_active = true);


--
-- TOC entry 5185 (class 1259 OID 17102)
-- Name: idx_complete_kits_active_by_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_complete_kits_active_by_product ON public.complete_kits USING btree (product_id, precio_total) WHERE (is_active = true);


--
-- TOC entry 5530 (class 0 OID 0)
-- Dependencies: 5185
-- Name: INDEX idx_complete_kits_active_by_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_complete_kits_active_by_product IS 'Optimiza búsqueda de kit completo al crear presupuesto';


--
-- TOC entry 5186 (class 1259 OID 16810)
-- Name: idx_complete_kits_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_complete_kits_product ON public.complete_kits USING btree (product_id) WHERE (is_active = true);


--
-- TOC entry 5238 (class 1259 OID 17069)
-- Name: idx_file_uploads_related; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_file_uploads_related ON public.file_uploads USING btree (related_table, related_id);


--
-- TOC entry 5239 (class 1259 OID 17070)
-- Name: idx_file_uploads_temp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_file_uploads_temp ON public.file_uploads USING btree (is_temporary, expires_at) WHERE (is_temporary = true);


--
-- TOC entry 5240 (class 1259 OID 17068)
-- Name: idx_file_uploads_uploader; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_file_uploads_uploader ON public.file_uploads USING btree (uploaded_by_type, uploaded_by_id);


--
-- TOC entry 5187 (class 1259 OID 16828)
-- Name: idx_materials_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_category ON public.materials USING btree (categoria) WHERE (is_active = true);


--
-- TOC entry 5188 (class 1259 OID 17100)
-- Name: idx_materials_low_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_low_stock ON public.materials USING btree (categoria, stock_actual) WHERE (((stock_actual)::integer <= (stock_minimo)::integer) AND (is_active = true));


--
-- TOC entry 5531 (class 0 OID 0)
-- Dependencies: 5188
-- Name: INDEX idx_materials_low_stock; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_materials_low_stock IS 'Optimiza alertas de stock bajo en dashboard del vendedor';


--
-- TOC entry 5189 (class 1259 OID 16830)
-- Name: idx_materials_search; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_search ON public.materials USING gin (to_tsvector('spanish'::regconfig, (((nombre)::text || ' '::text) || COALESCE(descripcion, ''::text))));


--
-- TOC entry 5190 (class 1259 OID 17097)
-- Name: idx_materials_search_spanish; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_search_spanish ON public.materials USING gin (to_tsvector('spanish'::regconfig, (((nombre)::text || ' '::text) || COALESCE(descripcion, ''::text)))) WHERE (is_active = true);


--
-- TOC entry 5532 (class 0 OID 0)
-- Dependencies: 5190
-- Name: INDEX idx_materials_search_spanish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_materials_search_spanish IS 'Búsqueda full-text para materiales en español';


--
-- TOC entry 5191 (class 1259 OID 16827)
-- Name: idx_materials_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_slug ON public.materials USING btree (slug) WHERE (is_active = true);


--
-- TOC entry 5192 (class 1259 OID 16829)
-- Name: idx_materials_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_stock ON public.materials USING btree (stock_actual) WHERE ((stock_actual)::integer <= (stock_minimo)::integer);


--
-- TOC entry 5222 (class 1259 OID 16931)
-- Name: idx_messages_request; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_request ON public.messages USING btree (request_id, created_at);


--
-- TOC entry 5223 (class 1259 OID 17095)
-- Name: idx_messages_request_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_request_created ON public.messages USING btree (request_id, created_at DESC);


--
-- TOC entry 5533 (class 0 OID 0)
-- Dependencies: 5223
-- Name: INDEX idx_messages_request_created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_messages_request_created IS 'Optimiza carga de conversaciones (chat) ordenadas cronológicamente';


--
-- TOC entry 5224 (class 1259 OID 16932)
-- Name: idx_messages_sender; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_sender ON public.messages USING btree (sender_type, sender_id);


--
-- TOC entry 5243 (class 1259 OID 17192)
-- Name: idx_mv_material_popularity_material; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_mv_material_popularity_material ON public.mv_material_popularity USING btree (material_id);


--
-- TOC entry 5242 (class 1259 OID 17179)
-- Name: idx_mv_monthly_statistics_month; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_mv_monthly_statistics_month ON public.mv_monthly_statistics USING btree (month);


--
-- TOC entry 5241 (class 1259 OID 17166)
-- Name: idx_mv_product_statistics_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_mv_product_statistics_product ON public.mv_product_statistics USING btree (product_id);


--
-- TOC entry 5227 (class 1259 OID 16956)
-- Name: idx_payments_budget; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_budget ON public.payments USING btree (budget_id);


--
-- TOC entry 5228 (class 1259 OID 17113)
-- Name: idx_payments_completed_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_completed_date ON public.payments USING btree (created_at, monto_total) WHERE (status = 'completado'::public.payment_status);


--
-- TOC entry 5534 (class 0 OID 0)
-- Dependencies: 5228
-- Name: INDEX idx_payments_completed_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_payments_completed_date IS 'Optimiza reportes de ingresos por periodo';


--
-- TOC entry 5229 (class 1259 OID 16958)
-- Name: idx_payments_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_created ON public.payments USING btree (created_at DESC);


--
-- TOC entry 5230 (class 1259 OID 16959)
-- Name: idx_payments_pending; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_pending ON public.payments USING btree (entregado) WHERE (entregado = false);


--
-- TOC entry 5231 (class 1259 OID 16955)
-- Name: idx_payments_request; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_request ON public.payments USING btree (request_id);


--
-- TOC entry 5232 (class 1259 OID 16957)
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- TOC entry 5233 (class 1259 OID 17094)
-- Name: idx_payments_status_entregado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_status_entregado ON public.payments USING btree (status, entregado, created_at DESC) WHERE (entregado = false);


--
-- TOC entry 5535 (class 0 OID 0)
-- Dependencies: 5233
-- Name: INDEX idx_payments_status_entregado; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_payments_status_entregado IS 'Optimiza listado de pagos pendientes de entrega';


--
-- TOC entry 5176 (class 1259 OID 16792)
-- Name: idx_product_prices_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_prices_active ON public.product_prices USING btree (is_active);


--
-- TOC entry 5177 (class 1259 OID 17101)
-- Name: idx_product_prices_active_by_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_prices_active_by_product ON public.product_prices USING btree (product_id, precio_completa) WHERE (is_active = true);


--
-- TOC entry 5536 (class 0 OID 0)
-- Dependencies: 5177
-- Name: INDEX idx_product_prices_active_by_product; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_product_prices_active_by_product IS 'Optimiza búsqueda de precio de maqueta al crear presupuesto';


--
-- TOC entry 5178 (class 1259 OID 16791)
-- Name: idx_product_prices_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_prices_product ON public.product_prices USING btree (product_id) WHERE (is_active = true);


--
-- TOC entry 5163 (class 1259 OID 16767)
-- Name: idx_products_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_active ON public.products USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- TOC entry 5164 (class 1259 OID 16765)
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5165 (class 1259 OID 16768)
-- Name: idx_products_featured; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_featured ON public.products USING btree (is_featured) WHERE ((is_featured = true) AND (deleted_at IS NULL));


--
-- TOC entry 5166 (class 1259 OID 17099)
-- Name: idx_products_featured_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_featured_active ON public.products USING btree (created_at DESC) WHERE ((is_featured = true) AND (is_active = true) AND (deleted_at IS NULL));


--
-- TOC entry 5537 (class 0 OID 0)
-- Dependencies: 5166
-- Name: INDEX idx_products_featured_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_products_featured_active IS 'Optimiza homepage mostrando productos destacados';


--
-- TOC entry 5167 (class 1259 OID 16769)
-- Name: idx_products_search; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_search ON public.products USING gin (to_tsvector('spanish'::regconfig, (((title)::text || ' '::text) || COALESCE(description, ''::text))));


--
-- TOC entry 5168 (class 1259 OID 17096)
-- Name: idx_products_search_spanish; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_search_spanish ON public.products USING gin (to_tsvector('spanish'::regconfig, (((title)::text || ' '::text) || COALESCE(description, ''::text)))) WHERE (deleted_at IS NULL);


--
-- TOC entry 5538 (class 0 OID 0)
-- Dependencies: 5168
-- Name: INDEX idx_products_search_spanish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_products_search_spanish IS 'Búsqueda full-text en español para productos. Ejemplo:
SELECT * FROM products WHERE to_tsvector(''spanish'', title || '' '' || description) @@ to_tsquery(''spanish'', ''célula & animal'');';


--
-- TOC entry 5169 (class 1259 OID 16766)
-- Name: idx_products_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_slug ON public.products USING btree (slug) WHERE (deleted_at IS NULL);


--
-- TOC entry 5170 (class 1259 OID 17098)
-- Name: idx_products_title_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_title_trgm ON public.products USING gin (title public.gin_trgm_ops) WHERE (deleted_at IS NULL);


--
-- TOC entry 5539 (class 0 OID 0)
-- Dependencies: 5170
-- Name: INDEX idx_products_title_trgm; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_products_title_trgm IS 'Búsqueda por similitud usando trigram. Útil para autocompletar y typos.
Ejemplo: SELECT * FROM products WHERE title % ''selula'' LIMIT 5; -- Encuentra "célula"';


--
-- TOC entry 5171 (class 1259 OID 17112)
-- Name: idx_products_view_count; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_view_count ON public.products USING btree (view_count DESC, created_at DESC) WHERE (deleted_at IS NULL);


--
-- TOC entry 5540 (class 0 OID 0)
-- Dependencies: 5171
-- Name: INDEX idx_products_view_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_products_view_count IS 'Optimiza reporte de productos más populares';


--
-- TOC entry 5197 (class 1259 OID 16864)
-- Name: idx_purchase_requests_budget; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_budget ON public.purchase_requests USING btree (budget_id) WHERE (budget_id IS NOT NULL);


--
-- TOC entry 5198 (class 1259 OID 16863)
-- Name: idx_purchase_requests_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_created ON public.purchase_requests USING btree (created_at DESC) WHERE (deleted_at IS NULL);


--
-- TOC entry 5199 (class 1259 OID 17111)
-- Name: idx_purchase_requests_date_range; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_date_range ON public.purchase_requests USING btree (created_at, status) WHERE (deleted_at IS NULL);


--
-- TOC entry 5541 (class 0 OID 0)
-- Dependencies: 5199
-- Name: INDEX idx_purchase_requests_date_range; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_purchase_requests_date_range IS 'Optimiza reportes de ventas por periodo (día, semana, mes)';


--
-- TOC entry 5200 (class 1259 OID 17103)
-- Name: idx_purchase_requests_no_budget; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_no_budget ON public.purchase_requests USING btree (created_at DESC) WHERE ((budget_created = false) AND (status = 'pendiente'::public.purchase_status) AND (deleted_at IS NULL));


--
-- TOC entry 5542 (class 0 OID 0)
-- Dependencies: 5200
-- Name: INDEX idx_purchase_requests_no_budget; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_purchase_requests_no_budget IS 'Optimiza listado de solicitudes nuevas que requieren atención del vendedor';


--
-- TOC entry 5201 (class 1259 OID 16865)
-- Name: idx_purchase_requests_pending; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_pending ON public.purchase_requests USING btree (status) WHERE ((status = 'pendiente'::public.purchase_status) AND (deleted_at IS NULL));


--
-- TOC entry 5202 (class 1259 OID 16861)
-- Name: idx_purchase_requests_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_product ON public.purchase_requests USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5203 (class 1259 OID 16862)
-- Name: idx_purchase_requests_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_status ON public.purchase_requests USING btree (status) WHERE (deleted_at IS NULL);


--
-- TOC entry 5204 (class 1259 OID 17091)
-- Name: idx_purchase_requests_status_budget; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_status_budget ON public.purchase_requests USING btree (status, budget_created) WHERE (deleted_at IS NULL);


--
-- TOC entry 5543 (class 0 OID 0)
-- Dependencies: 5204
-- Name: INDEX idx_purchase_requests_status_budget; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_purchase_requests_status_budget IS 'Optimiza queries que buscan solicitudes pendientes sin presupuesto';


--
-- TOC entry 5205 (class 1259 OID 16860)
-- Name: idx_purchase_requests_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_user ON public.purchase_requests USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 5206 (class 1259 OID 17092)
-- Name: idx_purchase_requests_user_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_purchase_requests_user_status ON public.purchase_requests USING btree (user_id, status, created_at DESC) WHERE (deleted_at IS NULL);


--
-- TOC entry 5544 (class 0 OID 0)
-- Dependencies: 5206
-- Name: INDEX idx_purchase_requests_user_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.idx_purchase_requests_user_status IS 'Optimiza dashboard del cliente filtrando por estado';


--
-- TOC entry 5143 (class 1259 OID 16703)
-- Name: idx_users_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_active ON public.users USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- TOC entry 5144 (class 1259 OID 16702)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 5149 (class 1259 OID 16723)
-- Name: idx_vendors_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vendors_active ON public.vendors USING btree (is_active) WHERE (deleted_at IS NULL);


--
-- TOC entry 5150 (class 1259 OID 16722)
-- Name: idx_vendors_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vendors_email ON public.vendors USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 5294 (class 2620 OID 17127)
-- Name: materials trigger_validate_material_stock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_validate_material_stock BEFORE UPDATE ON public.materials FOR EACH ROW WHEN (((new.stock_actual)::integer < 0)) EXECUTE FUNCTION public.validate_material_stock();


--
-- TOC entry 5545 (class 0 OID 0)
-- Dependencies: 5294
-- Name: TRIGGER trigger_validate_material_stock ON materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER trigger_validate_material_stock ON public.materials IS 'Previene que el stock de materiales sea negativo';


--
-- TOC entry 5291 (class 2620 OID 17125)
-- Name: product_prices trigger_validate_single_active_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_validate_single_active_price BEFORE INSERT OR UPDATE ON public.product_prices FOR EACH ROW EXECUTE FUNCTION public.validate_single_active_price();


--
-- TOC entry 5546 (class 0 OID 0)
-- Dependencies: 5291
-- Name: TRIGGER trigger_validate_single_active_price ON product_prices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER trigger_validate_single_active_price ON public.product_prices IS 'Valida que solo haya un precio activo por producto';


--
-- TOC entry 5297 (class 2620 OID 17079)
-- Name: budgets update_budgets_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5289 (class 2620 OID 17073)
-- Name: categories update_categories_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5293 (class 2620 OID 17076)
-- Name: complete_kits update_complete_kits_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_complete_kits_updated_at BEFORE UPDATE ON public.complete_kits FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5295 (class 2620 OID 17077)
-- Name: materials update_materials_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON public.materials FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5298 (class 2620 OID 17080)
-- Name: payments update_payments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5292 (class 2620 OID 17075)
-- Name: product_prices update_product_prices_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_product_prices_updated_at BEFORE UPDATE ON public.product_prices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5290 (class 2620 OID 17074)
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5296 (class 2620 OID 17078)
-- Name: purchase_requests update_purchase_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_purchase_requests_updated_at BEFORE UPDATE ON public.purchase_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5287 (class 2620 OID 17071)
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5288 (class 2620 OID 17072)
-- Name: vendors update_vendors_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_vendors_updated_at BEFORE UPDATE ON public.vendors FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5270 (class 2606 OID 16904)
-- Name: budget_items budget_items_budget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_budget_id_fkey FOREIGN KEY (budget_id) REFERENCES public.budgets(id) ON DELETE CASCADE;


--
-- TOC entry 5271 (class 2606 OID 16909)
-- Name: budget_items budget_items_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE SET NULL;


--
-- TOC entry 5268 (class 2606 OID 16879)
-- Name: budgets budgets_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5269 (class 2606 OID 16884)
-- Name: budgets budgets_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE SET NULL;


--
-- TOC entry 5265 (class 2606 OID 16805)
-- Name: complete_kits complete_kits_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complete_kits
    ADD CONSTRAINT complete_kits_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 5262 (class 2606 OID 17201)
-- Name: users fk_users_institution; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_institution FOREIGN KEY (institution_id) REFERENCES public.institutions(id);


--
-- TOC entry 5276 (class 2606 OID 17243)
-- Name: inventory_movements inventory_movements_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- TOC entry 5277 (class 2606 OID 17238)
-- Name: inventory_movements inventory_movements_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- TOC entry 5275 (class 2606 OID 17224)
-- Name: material_batches material_batches_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_batches
    ADD CONSTRAINT material_batches_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- TOC entry 5272 (class 2606 OID 16926)
-- Name: messages messages_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5273 (class 2606 OID 16950)
-- Name: payments payments_budget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_budget_id_fkey FOREIGN KEY (budget_id) REFERENCES public.budgets(id) ON DELETE SET NULL;


--
-- TOC entry 5274 (class 2606 OID 16945)
-- Name: payments payments_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5264 (class 2606 OID 16786)
-- Name: product_prices product_prices_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices
    ADD CONSTRAINT product_prices_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 5283 (class 2606 OID 17298)
-- Name: production_costs production_costs_production_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_costs
    ADD CONSTRAINT production_costs_production_id_fkey FOREIGN KEY (production_id) REFERENCES public.productions(id);


--
-- TOC entry 5281 (class 2606 OID 17281)
-- Name: production_losses production_losses_production_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_losses
    ADD CONSTRAINT production_losses_production_id_fkey FOREIGN KEY (production_id) REFERENCES public.productions(id);


--
-- TOC entry 5282 (class 2606 OID 17286)
-- Name: production_losses production_losses_reported_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_losses
    ADD CONSTRAINT production_losses_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES public.employees(id);


--
-- TOC entry 5278 (class 2606 OID 17267)
-- Name: productions productions_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productions
    ADD CONSTRAINT productions_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.material_batches(id);


--
-- TOC entry 5279 (class 2606 OID 17262)
-- Name: productions productions_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productions
    ADD CONSTRAINT productions_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- TOC entry 5280 (class 2606 OID 17257)
-- Name: productions productions_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productions
    ADD CONSTRAINT productions_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5263 (class 2606 OID 16760)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 5266 (class 2606 OID 16855)
-- Name: purchase_requests purchase_requests_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- TOC entry 5267 (class 2606 OID 16850)
-- Name: purchase_requests purchase_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 5285 (class 2606 OID 17326)
-- Name: sale_details sale_details_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT sale_details_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5286 (class 2606 OID 17321)
-- Name: sale_details sale_details_sale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sale_details
    ADD CONSTRAINT sale_details_sale_id_fkey FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- TOC entry 5284 (class 2606 OID 17310)
-- Name: sales sales_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2026-05-13 14:24:15

--
-- PostgreSQL database dump complete
--

\unrestrict 4JScm1ibRAHDS7H8XCXFd27dB9axdTI9hIjVGL6tvYVneTQMTcIMPdkl7ctnftM

