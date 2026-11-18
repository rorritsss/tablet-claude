@echo off
cd /d "%~dp0"
echo === PASO 1: Descargando todo (Platform Tools, driver, vbmeta, LineageOS) ===
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0descargar.ps1"
echo.
pause
