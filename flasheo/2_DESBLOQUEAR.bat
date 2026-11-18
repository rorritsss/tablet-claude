@echo off
cd /d "%~dp0platform-tools"
echo === PASO 2: Desbloquear bootloader (BORRA TODA LA TABLET) ===
echo Tablet encendida, conectada por USB, con Depuracion USB activada.
echo Si en la tablet aparece "Permitir depuracion USB", acepta.
pause
adb devices
adb reboot bootloader
echo Esperando que la tablet entre a fastboot (20 s)...
timeout /t 20
fastboot devices
echo Si arriba NO aparece un numero de serie, cierra esta ventana: falta el driver (ver LEEME).
pause
fastboot flashing unlock
echo.
echo EN LA TABLET: aprieta SUBIR VOLUMEN para confirmar el desbloqueo.
echo Cuando termine, la tablet queda en fastboot. Luego ejecuta 3_FLASHEAR.bat
pause
