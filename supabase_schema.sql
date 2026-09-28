-- ==========================================================
-- OftalmoCare - Esquema de Base de Datos para Supabase
-- ==========================================================

-- 1. Tabla de Médicos Oftalmólogos
CREATE TABLE IF NOT EXISTS public.doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    license_number TEXT,
    email TEXT,
    phone TEXT,
    photo_url TEXT,
    active BOOLEAN DEFAULT true
);

-- 2. Tabla de Bloqueos de Horarios y Vacaciones Médicas
CREATE TABLE IF NOT EXISTS public.doctor_blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    doctor_id UUID REFERENCES public.doctors(id) ON DELETE CASCADE,
    block_type TEXT NOT NULL CHECK (block_type IN ('vacaciones', 'horario', 'licencia', 'congreso', 'urgencia')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME WITHOUT TIME ZONE, -- Opcional si es bloqueo de día completo
    end_time TIME WITHOUT TIME ZONE,   -- Opcional si es bloqueo de día completo
    reason TEXT NOT NULL,
    created_by TEXT DEFAULT 'Administración'
);

-- 3. Tabla de Turnos Médicos
CREATE TABLE IF NOT EXISTS public.appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    doctor_id UUID REFERENCES public.doctors(id) ON DELETE RESTRICT,
    patient_name TEXT NOT NULL,
    patient_phone TEXT NOT NULL,
    patient_email TEXT,
    patient_dni TEXT,
    service_type TEXT NOT NULL, -- 'Consulta General', 'Fondo de Ojo', 'Presión Ocular / Glaucoma', 'Control Lentes', etc.
    appointment_date DATE NOT NULL,
    appointment_time TIME WITHOUT TIME ZONE NOT NULL,
    status TEXT NOT NULL DEFAULT 'confirmado' CHECK (status IN ('pendiente', 'confirmado', 'atendido', 'cancelado')),
    notes TEXT,
    reminder_sent BOOLEAN DEFAULT false,
    whatsapp_notification_sent BOOLEAN DEFAULT false
);

-- 4. Habilitar Row Level Security (RLS)
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctor_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- 5. Políticas RLS para lectura y escritura pública anónima controlada (o autenticada)
CREATE POLICY "Lectura pública de médicos activos" 
ON public.doctors FOR SELECT USING (active = true);

CREATE POLICY "Lectura pública de bloqueos para cálculo de disponibilidad" 
ON public.doctor_blocks FOR SELECT USING (true);

CREATE POLICY "Creación y administración de bloqueos" 
ON public.doctor_blocks FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Lectura pública de turnos para chequear ocupación" 
ON public.appointments FOR SELECT USING (true);

CREATE POLICY "Creación de turnos por pacientes" 
ON public.appointments FOR INSERT WITH CHECK (true);

CREATE POLICY "Actualización de estado de turnos" 
ON public.appointments FOR UPDATE USING (true) WITH CHECK (true);

-- 6. Inserción de Médicos Iniciales por defecto
INSERT INTO public.doctors (name, specialty, license_number, phone, email, photo_url)
VALUES 
    ('Dra. Sofía Albarracín', 'Especialista en Retina y Fondo de Ojo', 'MN 145.820', '+5491145892011', 'dra.albarracin@oftalmocare.com', 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=400'),
    ('Dr. Mariano Benítez', 'Glaucoma y Cirugía de Cataratas', 'MN 132.405', '+5491145892012', 'dr.benitez@oftalmocare.com', 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=400'),
    ('Dra. Lucía Valenzuela', 'Oftalmología Pediátrica y Estrabismo', 'MN 168.910', '+5491145892013', 'dra.valenzuela@oftalmocare.com', 'https://images.unsplash.com/photo-1594824813511-13c5188f5d05?auto=format&fit=crop&q=80&w=400')
ON CONFLICT DO NOTHING;
