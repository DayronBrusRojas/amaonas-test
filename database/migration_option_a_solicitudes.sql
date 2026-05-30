-- ===================================================================
-- MIGRACIÓN DE ESTRUCTURA RELACIONAL (OPCIÓN A - TABLAS SEPARADAS)
-- ===================================================================

-- 1. Crear tipo ENUM para el tipo de servicio de explicación solicitado
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'explanation_type') THEN
        CREATE TYPE explanation_type AS ENUM ('video', 'presencial', 'ambos');
    END IF;
END$$;

-- 2. Crear tabla kit_maquetas (para compras de kits de maquetas del catálogo)
CREATE TABLE IF NOT EXISTS kit_maquetas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_request_id UUID NOT NULL REFERENCES purchase_requests(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    product_name VARCHAR(255) NOT NULL,
    product_slug VARCHAR(255),
    cantidad INT NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    precio_unitario_referencia NUMERIC(10,2) CHECK (precio_unitario_referencia >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 3. Crear tabla kit_customized_materials (para los cambios de materiales de inventario de una maqueta)
CREATE TABLE IF NOT EXISTS kit_customized_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_request_id UUID NOT NULL REFERENCES purchase_requests(id) ON DELETE CASCADE,
    material_id UUID NOT NULL REFERENCES materials(id) ON DELETE RESTRICT,
    material_name VARCHAR(255) NOT NULL,
    material_unit VARCHAR(50) NOT NULL,
    cantidad NUMERIC(10,2) NOT NULL CHECK (cantidad > 0),
    costo_unitario_referencia NUMERIC(10,2) NOT NULL CHECK (costo_unitario_referencia >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 4. Crear tabla kit_personal_materials (para materiales libres que el cliente mismo traerá)
CREATE TABLE IF NOT EXISTS kit_personal_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_request_id UUID NOT NULL REFERENCES purchase_requests(id) ON DELETE CASCADE,
    material_name VARCHAR(255) NOT NULL,
    cantidad NUMERIC(10,2) NOT NULL CHECK (cantidad > 0),
    descripcion TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 5. Crear tabla request_preferred_materials (preferencias o sugerencias extras del cliente)
CREATE TABLE IF NOT EXISTS request_preferred_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_request_id UUID NOT NULL REFERENCES purchase_requests(id) ON DELETE CASCADE,
    material_id UUID REFERENCES materials(id) ON DELETE SET NULL,
    material_name VARCHAR(255) NOT NULL,
    razon_preferencia TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 6. Crear tabla budget_explanation_services (para los detalles del servicio de explicación 1:1 del presupuesto)
CREATE TABLE IF NOT EXISTS budget_explanation_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    budget_id UUID NOT NULL UNIQUE REFERENCES budgets(id) ON DELETE CASCADE,
    incluido BOOLEAN NOT NULL DEFAULT TRUE,
    tipo_evento VARCHAR(100),
    cantidad_personas INT CHECK (cantidad_personas > 0),
    duracion_minutos INT CHECK (duracion_minutos > 0),
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 7. Eliminar campos JSONB y TEXT[] obsoletos de purchase_requests
ALTER TABLE purchase_requests DROP COLUMN IF EXISTS kits_maquetas;
ALTER TABLE purchase_requests DROP COLUMN IF EXISTS materiales_seleccionados;

-- 8. Rediseñar campos de adelanto en budgets (reemplaza JSONB por columnas planas)
ALTER TABLE budgets DROP COLUMN IF EXISTS servicio_explicacion;
ALTER TABLE budgets DROP COLUMN IF EXISTS adelanto;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS adelanto_requerido BOOLEAN DEFAULT FALSE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS adelanto_porcentaje INT DEFAULT 0 CHECK (adelanto_porcentaje >= 0 AND adelanto_porcentaje <= 100);
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS adelanto_monto NUMERIC(10,2) DEFAULT 0.00 CHECK (adelanto_monto >= 0);

-- 9. Rediseñar campos de pago y adelanto en payments (reemplaza JSONB por columnas planas)
ALTER TABLE payments DROP COLUMN IF EXISTS adelanto;
ALTER TABLE payments DROP COLUMN IF EXISTS pago_final;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS adelanto_monto NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (adelanto_monto >= 0);
ALTER TABLE payments ADD COLUMN IF NOT EXISTS adelanto_pagado BOOLEAN DEFAULT FALSE;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS adelanto_fecha_pago TIMESTAMP WITH TIME ZONE;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS adelanto_evidencia_url VARCHAR(500);
ALTER TABLE payments ADD COLUMN IF NOT EXISTS final_monto NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (final_monto >= 0);
ALTER TABLE payments ADD COLUMN IF NOT EXISTS final_pagado BOOLEAN DEFAULT FALSE;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS final_fecha_pago TIMESTAMP WITH TIME ZONE;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS final_evidencia_url VARCHAR(500);
