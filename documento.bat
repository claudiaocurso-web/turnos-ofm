@echo off
chcp 65001 > nul
title OftalmoCare - Sistema de Turnos Oftalmológicos
cls

:MENU
echo ===================================================================
echo     OFTALMOCARE - GESTION DE TURNOS OFTALMOLOGICOS
echo     Supabase + Google AI Studio + WhatsApp + GitHub + Netlify
echo ===================================================================
echo.
echo   [1] Iniciar Servidor de Desarrollo Local (npm run dev)
echo   [2] Probar Compilacion de Produccion (npm run build)
echo   [3] Sincronizar y Subir a GitHub (Git Add, Commit, Push)
echo   [4] Desplegar a Netlify (Netlify CLI o Web)
echo   [5] Sincronizacion Completa (Build + GitHub + Netlify)
echo   [6] Ver / Configurar Variables de Entorno (.env)
echo   [7] Abrir Esquema SQL de Supabase (supabase_schema.sql)
echo   [0] Salir
echo.
echo ===================================================================
set /p OPCION="Selecciona una opcion [0-7]: "

if "%OPCION%"=="1" goto DEV
if "%OPCION%"=="2" goto BUILD
if "%OPCION%"=="3" goto GITHUB
if "%OPCION%"=="4" goto NETLIFY
if "%OPCION%"=="5" goto SYNC_ALL
if "%OPCION%"=="6" goto CONFIG_ENV
if "%OPCION%"=="7" goto OPEN_SQL
if "%OPCION%"=="0" goto EXIT
goto MENU

:DEV
cls
echo [INFO] Iniciando servidor de desarrollo Vite en http://localhost:3000...
echo Presiona Ctrl+C para detener el servidor.
echo.
call npm run dev
pause
goto MENU

:BUILD
cls
echo [INFO] Ejecutando compilacion optimizada de produccion...
call npm run build
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [EXITO] Compilacion completada sin errores. La carpeta 'dist' esta lista.
) else (
    echo.
    echo [ERROR] Hubo un error al compilar el proyecto.
)
pause
goto MENU

:GITHUB
cls
echo ===================================================================
echo               SINCRONIZACION CON GITHUB
echo ===================================================================
echo.

:: Verificar si git esta instalado
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git no esta instalado o no se encuentra en el PATH.
    echo Por favor descarga e instala Git desde https://git-scm.com/
    pause
    goto MENU
)

:: Inicializar git si no existe
if not exist ".git" (
    echo [INFO] Inicializando nuevo repositorio Git local...
    git init
    git branch -M main
)

:: Verificar remoto
git remote get-url origin >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ATENCION] No hay un repositorio remoto de GitHub vinculado.
    set /p REPO_URL="Pega la URL de tu repositorio de GitHub (ej: https://github.com/usuario/turnos-oftalmo.git): "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
        echo [OK] Remoto origin configurado.
    ) else (
        echo [INFO] Operacion cancelada. No se configuro remoto.
        pause
        goto MENU
    )
)

set /p COMMIT_MSG="Ingresa el mensaje de commit (o presiona ENTER para 'Actualizacion de OftalmoCare'): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Actualizacion de OftalmoCare - Sistema de Turnos

echo.
echo [1/3] Preparando archivos...
git add .

echo [2/3] Creando commit...
git commit -m "%COMMIT_MSG%"

echo [3/3] Enviando cambios a GitHub (main)...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [EXITO] Cambios sincronizados exitosamente con GitHub.
) else (
    echo.
    echo [ATENCION] Si es la primera vez que haces push, verifica tus credenciales de GitHub
    echo o ejecuta: git push -u origin main --force
)
pause
goto MENU

:NETLIFY
cls
echo ===================================================================
echo                   DESPLIEGUE EN NETLIFY
echo ===================================================================
echo.
echo Opciones de despliegue para Netlify:
echo 1) Despliegue automatico via Netlify CLI (npx netlify-cli)
echo 2) Abrir Netlify Web (conecta tu repo de GitHub con un clic)
echo.
set /p NET_OPT="Elige [1 o 2]: "

if "%NET_OPT%"=="1" (
    echo [INFO] Compilando proyecto antes del despliegue...
    call npm run build
    echo.
    echo [INFO] Iniciando Netlify Deploy...
    call npx netlify-cli deploy --prod --dir=dist
    pause
    goto MENU
)

if "%NET_OPT%"=="2" (
    echo [INFO] Abriendo Netlify en el navegador...
    start https://app.netlify.com/start
    echo.
    echo Pasos en Netlify:
    echo 1. Selecciona 'Import an existing project' -> GitHub.
    echo 2. Elige tu repositorio 'Turnos'.
    echo 3. Netlify detectara automaticamente:
    echo    - Build command: npm run build
    echo    - Publish directory: dist
    echo 4. En 'Environment Variables', agrega:
    echo    - VITE_SUPABASE_URL
    echo    - VITE_SUPABASE_ANON_KEY
    echo    - VITE_GEMINI_API_KEY
    echo    - VITE_CLINIC_WHATSAPP
    pause
    goto MENU
)
goto MENU

:SYNC_ALL
cls
echo ===================================================================
echo          SINCRONIZACION COMPLETA (BUILD + GITHUB + NETLIFY)
echo ===================================================================
echo.
echo Paso 1: Compilando aplicacion...
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Fallo la compilacion. Abortando sincronizacion.
    pause
    goto MENU
)

echo.
echo Paso 2: Sincronizando con GitHub...
git add .
git commit -m "Auto-deploy y actualizacion de OftalmoCare"
git push origin main

echo.
echo Paso 3: Verificando despliegue de Netlify...
echo Si vinculaste Netlify a GitHub, el despliegue comenzara automaticamente en la nube.
echo Opcionalmente, puedes ejecutar 'npx netlify-cli deploy --prod --dir=dist'.
pause
goto MENU

:CONFIG_ENV
cls
if not exist ".env" (
    echo [INFO] Creando archivo .env a partir de .env.example...
    copy .env.example .env >nul
)
echo [INFO] Abriendo archivo .env en el bloc de notas para configurar claves...
start notepad .env
echo.
echo Una vez guardado el archivo .env, reinicia el servidor local (opcion 1).
pause
goto MENU

:OPEN_SQL
cls
echo [INFO] Abriendo archivo supabase_schema.sql en el bloc de notas...
start notepad supabase_schema.sql
echo.
echo Copia todo su contenido y pegalo en el SQL Editor de tu proyecto en https://supabase.com
pause
goto MENU

:EXIT
echo.
echo ¡Hasta luego! Gracias por usar OftalmoCare.
exit
