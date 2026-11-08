#!/usr/bin/env bash
#
# notas-zopeck-new.sh - Creador de notas optimizado para sistema
#

NOTAS_DIR="${HOME}/.local/share/notas-zopeck"
FUNCIONES="/usr/share/notas-zopeck/funciones"

# Inicializar entorno
source "${FUNCIONES}/inicializa_entorno"
inicializar_entorno_usuario

mkdir -p "$NOTAS_DIR"

source "${FUNCIONES}/autoguardar_nota_zopeck"

FECHA_STAMP=$(date +"%Y%m%d_%H%M%S")
RUTA_NOTA="${NOTAS_DIR}/nota_${FECHA_STAMP}.txt"

# Crear archivo base inicial
touch "$RUTA_NOTA"

# YAD imprime por stdout todo el texto editado cuando se presiona 'Cerrar' o la 'X'
CONTENIDO=$(yad --text-info --wrap \
    --title="Nueva Nota Zopeck" \
    --window-icon="document-new" \
    --filename="$RUTA_NOTA" \
    --width=700 --height=500 --center \
    --editable \
    --button="Cerrar:0")

# Procesar guardado y actualización de caché
autoguardar_nota_zopeck "$CONTENIDO" "$RUTA_NOTA"
