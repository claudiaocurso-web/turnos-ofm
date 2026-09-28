# 👁️ OftalmoCare - Sistema Integral de Turnos Oftalmológicos

Plataforma web médica profesional diseñada con una paleta cromática armónica de **verde pastel y lavanda**, orientada a consultorios y clínicas oftalmológicas. Integra reserva de turnos online, triage con **Google AI Studio (Gemini)**, recordatorios y confirmaciones automáticas por **WhatsApp**, panel de control para médicos con **bloqueo de horarios y vacaciones**, base de datos en **Supabase** y automatización con **GitHub**, **Netlify** y el script `documento.bat`.

---

## 🎨 Paleta de Colores
- **Verde Pastel**: Menta suave (`#D8F3DC`), Salvia (`#B7E4C7`), Verde médico (`#52B788`) y Forestal profundo (`#2D6A4F`).
- **Lavanda**: Lavanda claro (`#EAE4F8`), Acento lavanda (`#C7B9F1`), Violeta clínico (`#7B5EA7`).
- **Fondo**: Blanco luminoso con matiz pastel relajante (`#FAF9FD`).

---

## 🚀 Características Principales

### 1. Sistema de Turnos Online para Pacientes
- Selección ágil de especialidad (Consulta General, Fondo de Ojo, Glaucoma, Cataratas, Oftalmopediatría, Lentes de Contacto).
- Selección de médico especialista.
- **Validación instantánea de disponibilidad**: el sistema bloquea automáticamente los días y horarios donde el médico se encuentra de vacaciones, en congreso o con franjas reservadas.
- Confirmación directa con un clic hacia el **WhatsApp del consultorio** con mensaje formal preformateado.

### 2. Panel Médico & Secretaría (Gestión Interna)
- **Agenda de Turnos**: listado completo con buscador en tiempo real (por nombre, DNI, teléfono o médico) y selector de estados (`Confirmado`, `Atendido`, `Cancelado`).
- **Recordatorios por WhatsApp al Paciente**: botón que abre el chat de WhatsApp con el paciente con indicaciones previas personalizadas (ej. *fondo de ojo: no manejar, traer acompañante y lentes oscuros por dilatación pupilar; control de lentes: suspender lentes de contacto 24h antes*). Marca automáticamente el turno como notificado con un check verde.
- **Gestión de Bloqueos & Vacaciones**:
  - Registro de licencias, vacaciones anuales, congresos o emergencias.
  - Bloqueo por días completos o por franjas horarias específicas (ej. *bloquear de 14:00 a 16:00 hs por quirófano*).
  - Eliminación o reactivación de horarios con un solo clic.

### 3. Asistente con Google AI Studio (Gemini)
- Chatbot clínico inteligente con system prompt oftalmológico.
- Brinda orientación rápida sobre síntomas frecuentes, preparación para estudios oculares y recomendación de qué especialista consultar.
- Incluye preguntas frecuentes en un solo clic y botón para reservar turno de inmediato.
- Cuenta con fallback interactivo en caso de no contar aún con API Key cargada.

### 4. Base de Datos en Supabase
- Script SQL completo `supabase_schema.sql` con tablas para `doctors`, `appointments` y `doctor_blocks`.
- Soporte para Row Level Security (RLS).
- **Modo Híbrido**: si no se configuran las credenciales en `.env`, la aplicación funciona automáticamente con almacenamiento local (`localStorage`) para que puedas probarla inmediatamente.

### 5. Automatización Windows con `documento.bat`
Un menú interactivo en Windows para:
1. Iniciar servidor local (`npm run dev`).
2. Probar compilación (`npm run build`).
3. Sincronizar y subir a GitHub con Git Commit y Push guiado.
4. Desplegar en Netlify.
5. Configurar variables de entorno y abrir el script SQL de Supabase.

---

## 🛠️ Puesta en Marcha

### Opción A: Usando el script interactivo (Recomendado en Windows)
Haz doble clic sobre el archivo **`documento.bat`** o ejecútalo desde tu terminal:
```cmd
documento.bat
```

### Opción B: Por comandos manuales
1. Instalar dependencias:
   ```bash
   npm install
   ```
2. Iniciar en modo desarrollo:
   ```bash
   npm run dev
   ```
3. Compilar para producción:
   ```bash
   npm run build
   ```

---

## 🔑 Configuración de Variables de Entorno (`.env`)

Copia el archivo `.env.example` a `.env`:
```env
# Supabase
VITE_SUPABASE_URL=https://tu-id.supabase.co
VITE_SUPABASE_ANON_KEY=tu-anon-key-de-supabase

# Google AI Studio (Gemini API)
VITE_GEMINI_API_KEY=tu-api-key-de-google-ai-studio

# WhatsApp de la Clínica
VITE_CLINIC_WHATSAPP=5491145892011
VITE_CLINIC_NAME="OftalmoCare Consultorios Oftalmológicos"
```

---

## 🌐 Despliegue en Netlify

El proyecto ya incluye `netlify.toml` preconfigurado con redirección para SPA:
1. En Netlify, selecciona **Add new site** > **Import an existing project** > **GitHub**.
2. Selecciona tu repositorio de **Turnos**.
3. En **Environment variables**, añade las mismas variables de tu `.env`.
4. ¡Listo! Cada vez que hagas `git push` a `main` (o uses la opción 3 o 5 de `documento.bat`), Netlify compilará y actualizará el sitio automáticamente.
