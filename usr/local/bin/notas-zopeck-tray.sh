#!/usr/bin/env bash
# ==============================================================================
# Script: notas-zopeck-tray.sh (Versión Base Restaurada y Estable)
# Descripción: Tray de sistema en YAD con FIFO, iconos originales y opciones base.
# ==============================================================================

NOTAS_DIR="${HOME}/.local/share/notas-zopeck"
PIPE_YAD="/tmp/busqueda_notas_tray_lab_${USER}.fifo"
HELP_FILE="/usr/share/notas-zopeck/notas_zopeck_help.txt"
FUNCIONES="/usr/share/notas-zopeck/funciones"

# Inicializar entorno de usuario
source "${FUNCIONES}/inicializa_entorno"
inicializar_entorno_usuario

INIT_IMAGE="notas_bw"
INIT_CMD="/usr/local/bin/notas-zopeck.sh"
CACHE_MAPA="/dev/shm/notas_zopeck_mapa_${USER}.tmp"
SESION_RECIENTES="/tmp/notas_zopeck_recientes_${USER}.tmp"

# Validar si el mapa en RAM existe y no está vacío. Si no existe, genera la precarga.
if [ ! -s "$CACHE_MAPA" ]; then
    nice -n 19 ionice -c 3 "$INIT_CMD" --preload &
fi

# Asegurar directorio de notas
mkdir -p "$NOTAS_DIR"

# Evitar múltiples instancias
if pgrep -f "yad --notification.*$PIPE_YAD" >/dev/null 2>&1; then
    exit 0
fi

# Limpieza al salir
rm -f "$PIPE_YAD"
trap 'kill $(jobs -p) 2>/dev/null; rm -f "$PIPE_YAD"' EXIT INT TERM

mkfifo "$PIPE_YAD"
exec 3<> "$PIPE_YAD"

# --- MENÚ CONTEXTUAL BASE (Estable y Original) ---
O_ULTIMAS="Mostrar las ultimas veinte notas!sh -c \"${INIT_CMD} --recent\"!slideshow-emblem"
O_LISTA="Mostrar TODAS las notas (Cache RAM)!sh -c \"${INIT_CMD} --todas\"!homebank"
O_CREAR="Crear una nota nueva!sh -c \"/usr/local/bin/notas-zopeck-new.sh\"!org.gnome.gedit"

O_BACKUP="Respaldar Notas Zopeck...!bash -c \"source ${FUNCIONES}/respaldar_notas_zopeck && respaldar_notas_zopeck\"!gnome-disks"
O_GESTION_BK="Gestión de Respaldos...!bash -c \"source ${FUNCIONES}/gestion_backup_zopeck && gestion_backup_zopeck\"!preferences-system"

O_AYUDA="Ayuda!bash -c \"yad --text-info --skip-taskbar --no-buttons --formatted --wrap --width=810 --height=655 --title='Ayuda' --filename='$HELP_FILE' --center --undecorated --timeout=180 --timeout-indicator=bottom\"!help-browser"
O_ACERCA="Acerca de...!bash -c \"yad --about \
    --pname='Notas Zopeck' \
    --pversion='version 10.0 - Session LRU + btime Order' \
    --copyright='Copyleft (GPLv3 / Dominio Público)' \
    --comments='Sistema ultrarrápido impulsado por eventos, precarga en RAM y ordenamiento dinámico por sesión.' \
    --authors='Mark' \
    --website-label='Notas Zopeck en GitHub' \
    --window-icon='help-about'\"!help-about"

O_EXIT="Cerrar Búsqueda Notas!sh -c 'echo quit > $PIPE_YAD'!application-exit"

MENU_BASE="${O_ULTIMAS}|${O_LISTA}|${O_CREAR}|----------------------------|${O_BACKUP}|${O_GESTION_BK}|----------------------------|${O_AYUDA}|${O_ACERCA}|----------------------------|${O_EXIT}"

# Función para actualizar el menú estático en el tray
actualizar_menu_tray() {
    echo "menu:${MENU_BASE}" >&3
}

# Función para contar notas
obtener_cant_notas() {
    find "$NOTAS_DIR" -maxdepth 1 -name "*.txt" 2>/dev/null | wc -l
}

CANT_INICIAL=$(obtener_cant_notas)
BASE_TEXT="Sistema de búsqueda de notas \"Zopeck\".\nHaga clic aqui para buscar en sus notas.\n\nCantidad de notas a la fecha: "
BASE_TEXT_INIT="${BASE_TEXT}${CANT_INICIAL}"

# Lanzador del tray con el motor FIFO original (--listen)[cite: 2, 3]
yad --notification \
    --listen \
    --image="$INIT_IMAGE" \
    --text="$BASE_TEXT_INIT" \
    --command="$INIT_CMD" <&3 2>/dev/null &

YAD_PID=$!

# Actualizar el menú inicial justo al arrancar
actualizar_menu_tray

# Monitoreo combinado: Actualiza únicamente el tooltip según los cambios en el directorio
(
    CANT_ANTERIOR=-1
    while kill -0 $YAD_PID 2>/dev/null; do
        CANT_ACTUAL=$(obtener_cant_notas)
        if [ "$CANT_ACTUAL" -ne "$CANT_ANTERIOR" ]; then
            echo "tooltip:$BASE_TEXT $CANT_ACTUAL" >&3
            CANT_ANTERIOR=$CANT_ACTUAL
        fi
        sleep 5
    done
) &

wait $YAD_PID 2>/dev/null
exec 3>&-
