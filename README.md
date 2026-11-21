# 📝 Notas Zopeck

**Notas Zopeck** es un sistema ultrarrápido y liviano para la búsqueda, creación, visualización y gestión de notas personales en entornos GNU/Linux. 

Diseñado bajo una filosofía de consumo mínimo de recursos, aprovecha la memoria RAM (`/dev/shm`) para precargar índices, utiliza un motor de eventos eficiente en Bash/AWK y ofrece una interfaz gráfica minimalista sobre `yad`.

---

## ✨ Características Principales

- ⚡ **Caché ultrarrápida en RAM:** Precarga de notas en `/dev/shm` mediante banderas en memoria y construcción atómica, garantizando respuestas instantáneas sin consumo innecesario de disco.
- 🔍 **Búsqueda Avanzada:** Filtrado por texto o patrones con soporte para operadores lógicos (**AND / OR**), coincidencia exacta de palabras y sensibilidad a mayúsculas/minúsculas.
- 📌 **Bandeja de Sistema (Tray):** Icono residente en la barra de tareas con menú contextual completo, estado interactivo y monitor de cantidad de notas.
- 🕒 **Acceso Rápido a Recientes (LRU):** Panel dedicado con el listado de las últimas 10 notas accedidas a un solo clic.
- 💾 **Gestión Inteligente de Respaldos:** 
  - Sincronización diferencial con `rsync`.
  - Detección automática de hardware (discos USB, tarjetas SD, eMMC, carpetas en red como SSHFS/GVfs).
  - Algoritmo *Smart Speed Upgrade* para sugerir el medio de almacenamiento de menor latencia.
  - Historial de destinos con opción de fijar dispositivo preferido o purgar copias.
- 🔒 **Control de Instancias:** Previene la apertura duplicada de notas en edición o lectura.

---

## 🛠️ Requisitos del Sistema

- **Sistema Operativo:** GNU/Linux (Debian, Ubuntu, Linux Mint, Sparky Linux o derivados).
- **Intérprete:** `bash` (>= 4.0)
- **Dependencias base:** `yad`, `rsync`, `coreutils`, `findutils`, `gawk`, `procps`

---

## 🚀 Instalación

### Método 1: Paquete Debian (`.deb`)

Puedes descargar el archivo precompilado desde la sección de **Releases** de este repositorio e instalarlo ejecutando:

```bash
sudo dpkg -i notas-zopeck_1.0-1_amd64.deb
sudo apt-get install -f   # Para resolver dependencias si fuera necesario
```

### Método 2: Instalación Manual desde el Código Fuente
Si prefieres instalar directamente la estructura de archivos en tu sistema:

# Clonar el repositorio
```bash
git clone [https://github.com/zopeck/notas-zopeck.git](https://github.com/zopeck/notas-zopeck.git)
cd notas-zopeck
```

# Copiar ejecutables y librerías
```bash
sudo cp -r usr/local/bin/* /usr/local/bin/
sudo cp -r usr/share/notas-zopeck /usr/share/
sudo cp -r usr/share/applications/* /usr/share/applications/
sudo cp -r usr/share/pixmaps/* /usr/share/pixmaps/
```

# Actualizar la base de datos de iconos de escritorio
```bash
update-desktop-database -q
```

## 📖 Uso
Inicio de la Bandeja de Sistema (Tray)
Al iniciar tu entorno de escritorio (como XFCE), puedes lanzar el demonio del tray ejecutando:

```bash
/usr/local/bin/notas-zopeck-tray.sh
```
## Opciones por Línea de Comandos
El ejecutable principal /usr/local/bin/notas-zopeck.sh admite los siguientes argumentos:

notas-zopeck.sh --recent : Muestra la ventana interactiva con las últimas 20 notas.

notas-zopeck.sh --todas : Abre el listado completo de notas indexadas.

notas-zopeck.sh --buscar : Abre el formulario de búsqueda avanzada.

notas-zopeck.sh --backup : Inicia el asistente de respaldo inteligente.

notas-zopeck-new.sh : Abre el editor directo para crear una nueva nota.

## 📁 Ubicación de los Archivos
Notas de usuario: ~/.local/share/notas-zopeck/

Configuración de usuario: ~/.config/notas_zopeck.conf

Historial de respaldos: ~/.config/zopeck_bk_historial.log

Caché en RAM: /dev/shm/notas_zopeck_mapa_${USER}.tmp

## 🗑️ Desinstalación
Si instalaste la aplicación vía .deb, puedes removerla por completo ejecutando:

```bash
sudo apt remove notas-zopeck
```

## 👤 Autor
Mark (Marco A. Rodriguez G.)
GitHub: @zopeck
Email: zopeck@gmail.com

## 📄 Licencia
Este proyecto está liberado bajo la licencia GPLv3 / Dominio Público. Puedes redistribuirlo, modificarlo y adaptarlo libremente.
