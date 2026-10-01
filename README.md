# Notas Zopeck

---
**Notas Zopeck** es un sistema de creación, búsqueda y gestión de notas en texto plano ultrarrápido y liviano para entornos Linux. Construido en Bash sobre **YAD** (Yet Another Dialog) y herramientas GNU, está diseñado para consumir el mínimo de recursos sin perder rendimiento, resultando ideal para equipos de prestaciones modestas (como laptops ligeras o Netbooks) o entornos minimalistas. Se recomienda su uso sobre X11, no está optimizado para sistemas basados en Wayland.

## 🛠️ Características Principales

* **Autoguardado inteligente:** Guarda el contenido automáticamente al cerrar o descartar la ventana de edición. Si la nota se deja vacía o solo con espacios, el sistema la limpia y elimina automáticamente.
* **Caché y aceleración en RAM (`/dev/shm`):** Construye y consulta el mapa de notas directamente en memoria para ofrecer tiempos de búsqueda e interacciones instantáneas.
* **Verificación por Flag atómico:** Controla la actualización de la caché en RAM mediante banderas en `/dev/shm` en apenas ~0.05 ms, evitando lecturas innecesarias en disco.
* **Búsqueda avanzada:** Soporta operadores lógicos (`AND` / `OR`), distinción de mayúsculas/minúsculas y coincidencias por palabra exacta sobre el contenido de las notas.
* **Ordenamiento dinámico por sesión (LRU + btime):** Mantiene en las primeras posiciones las notas creadas, editadas o consultadas recientemente durante la sesión activa.
* **Bandeja de sistema (Tray Applet):** Monitor para la barra de tareas que muestra la cantidad de notas en tiempo real y permite acceso directo al creador, buscador y respaldos.
* **Centro de Gestión de Respaldos:**
  * Sincronización mediante `rsync` con barra de progreso.
  * Identificación precisa del hardware de almacenamiento (fabricante, modelo, tamaño real del disco y número de serie).
  * Soporte para dispositivos locales (USB, eMMC, SD) y montajes remotos (SSHFS, GVfs, Samba/NFS).
  * Definición de dispositivo preferido con espera activa y reconexión automática.

---

## 📋 Requisitos del Sistema

* **Sistema Operativo:** Linux / POSIX-compliant
* **Intérprete:** `bash` (v4.0 o superior)
* **Interfaz:** `yad` (Yet Another Dialog)
* **Herramientas GNU/Coreutils:** `gawk`, `findutils`, `util-linux`, `coreutils`
* **Sincronización:** `rsync`

---

## 🚀 Estructura del Proyecto e Instalación

Para mantener la modularidad, el sistema se divide en ejecutables principales y funciones auxiliares.

### 1. Estructura de archivos sugerida

```text
~/.local/bin/
├── busqueda_notas_10_lab.sh
├── busqueda_notas_tray_10_lab.sh
├── busqueda_notas_tray_genera_filename_lab.sh
└── funciones/
    ├── autoguardar_nota_zopeck
    ├── buscar_texto_formulario
    ├── cargar_todas_las_notas
    ├── generar_mapa_ram
    ├── gestion_backup_zopeck
    ├── info_dispositivo_zopeck
    ├── mostrar_lista_yad
    ├── reordenar_resultados_sesion
    ├── respaldar_notas_zopeck
    └── verificar_o_construir_cache
```

### 2. Permisos de ejecucion
Asigna permisos de ejecucion a los scripts principales:
```text
chmod +x ~/.local/bin/busqueda_notas_*
```
### 3. Directorio de notas
Las notas se guardan automaticamente en formato ```.txt``` dentro de:
```text
~/.local/share/notas
```
---

## 💻 Modo de Uso

Búsqueda y Gestión por Línea de Comandos
Puedes lanzar el script principal pasando diferentes argumentos según lo que necesites:

```text
# Abrir el formulario de búsqueda avanzada (por defecto)
busqueda_notas_10_lab.sh --buscar

# Listar las últimas 20 notas ordenadas por fecha/sesión
busqueda_notas_10_lab.sh --ultimas

# Listar la totalidad de las notas registradas
busqueda_notas_10_lab.sh --todas

# Ejecutar la rutina de respaldo inteligente
busqueda_notas_10_lab.sh --backup
```

Indicador en la Bandeja del Sistema (Tray)
Para activar el lanzador y monitor persistente en la barra de tareas al iniciar sesión:

```text
~/.local/bin/busqueda_notas_tray_10_lab.sh &
```

---
## 📄 Licencia

Este proyecto se distribuye bajo la licencia GPLv3 / Dominio Público (Copyleft).
