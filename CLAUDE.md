# Tablet Lenovo TB-X606F con LineageOS — contexto para Claude Code

Este Claude Code corre **en la propia tablet**. Explicar todo en español, breve.

## Hardware y sistema
- Lenovo Tab M10 FHD Plus **TB-X606F** (fastboot product `achilles6_row_wifi`), MediaTek Helio P22T, arm64.
- Particionado **A-only**, sin particiones dinámicas, system ~3.6 GB.
- Sistema: **LineageOS 19.1 GSI** (Android 12L) de Andy Yan,
  `lineage-19.1-20250606-UNOFFICIAL-arm64_bvN` — vanilla, **sin Google**, sin root.
- Bootloader **desbloqueado** (el aviso "Orange State" al arrancar es normal).
- Flasheado el 2026-11-18 desde el PC Windows: vbmeta vacío (verity off) → system → `fastboot -w`.

## Cómo corre Claude Code aquí
- Apps desde **F-Droid** (Termux, etc.) y **Aurora Store** para apps de Play Store.
- Termux directo NO sirve: no existe binario nativo `linux-arm64-android` de Claude Code.
- Por eso se usa **proot-distro Debian** dentro de Termux:
  ```
  proot-distro login debian
  claude
  ```
- Claude Code instalado con el instalador oficial (`curl -fsSL https://claude.ai/install.sh | bash`),
  binario en `~/.local/bin` (PATH agregado en `~/.bashrc` de Debian).
- Dentro de proot no se abren links en el navegador: copiar con mantener presionado → More → Select URL.
- El almacenamiento de Android se ve desde Termux tras `termux-setup-storage` (en `~/storage`);
  desde Debian, en `/data/data/com.termux/files/home/storage` si se monta con `--bind`.

## Limitaciones conocidas
- Sin Google Play Services: algunas apps (bancos, juegos con login Google) pueden fallar.
- GSI: posibles detalles con cámara/Bluetooth/brillo. Probar antes de asumir que algo es bug de una app.
- Sin OTA: actualizar = reflashear un GSI nuevo desde el PC.
- Helio P22T + poca RAM: preferir herramientas livianas, evitar procesos pesados en paralelo.

## Rescate
- Si queda en bootloop: en el PC, **Lenovo Software Fix** → Rescue (reinstala Android de fábrica).
- Scripts de flasheo usados (Windows) en `flasheo/`. Archivos grandes (system.img, vbmeta, platform-tools)
  quedaron en el PC en `C:\Users\Rorritttttsss\claude-scratch\TabletLineage`, no en este repo.

## Lecciones del flasheo (por si hay que repetirlo)
- `~/.android/adbkey` vacío en el PC → la tablet nunca pedía autorizar depuración. Borrar y reiniciar adb.
- En fastboot la tablet es `VID_0E8D&PID_201C`: asignar a mano "Android Bootloader Interface"
  (driver de Google, "Usar disco").
- `fastboot flashing unlock` reinicia y corta el USB; tras reconectar, las respuestas llegaban desfasadas
  → `fastboot reboot bootloader` lo arregla.
- SourceForge: mirror `?use_mirror=phoenixnap` fue rápido.
- npm 12 bloquea postinstall por defecto (`allow-scripts`).

## Ideas pendientes
- Instalar en Debian lo que haga falta según uso (python3, etc.).
- Opcional: Termux:API / Termux:Widget desde F-Droid (misma fuente que Termux).
