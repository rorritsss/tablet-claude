@echo off
cd /d "%~dp0platform-tools"
echo === PASO 3: Instalar LineageOS ligero ===
fastboot devices
pause
fastboot --disable-verity --disable-verification flash vbmeta "%~dp0vbmeta.img"
fastboot flash system "%~dp0system.img"
fastboot -w
fastboot reboot
echo.
echo Listo. El primer arranque puede tardar 5-10 minutos.
pause
