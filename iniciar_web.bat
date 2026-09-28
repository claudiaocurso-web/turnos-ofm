@echo off
chcp 65001 > nul
title OftalmoCare - Servidor Local
cls
echo ===================================================================
echo     OFTALMOCARE - INICIANDO SISTEMA DE TURNOS
echo ===================================================================
echo.
echo [INFO] Iniciando servidor de desarrollo...
echo [INFO] Tu navegador se abrira automaticamente en:
echo        http://localhost:3000
echo.
echo Presiona Ctrl+C en esta ventana cuando quieras cerrar la web.
echo ===================================================================
echo.

call npm run dev
pause
