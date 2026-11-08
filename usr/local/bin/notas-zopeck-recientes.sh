#!/usr/bin/env bash
# ==============================================================================
# Script: notas-zopeck-recientes.sh (v8.0 - Minimalista Centrado de 1 Clic)
# Descripción: Botonera limpia con centrado simétrico y respuesta de un solo clic
# ==============================================================================

# Evitar instancias múltiples de la ventana de recientes
TITULO_RECIENTES="Últimas 10 Notas Recientes"
if pgrep -f "yad --form.*--title=$TITULO_RECIENTES" >/dev/null 2>&1; then
    command -v wmctrl >/dev/null 2>&1 && wmctrl -F -a "$TITULO_RECIENTES" 2>/dev/null
    exit 0
fi

NOTAS_DIR="${HOME}/.local/share/notas-zopeck"
CACHE_MAPA="/dev/shm/notas_zopeck_mapa_${USER}.tmp"
SESION_RECIENTES="/tmp/notas_zopeck_recientes_${USER}.tmp"
INIT_CMD="/usr/local/bin/notas-zopeck.sh"
TMP_SELECCION="/dev/shm/notas_zopeck_sel_${USER}.tmp"

rm -f "$TMP_SELECCION"

# 1. Calcular total de notas registradas en el sistema (número en verde)
TOTAL_NOTAS=0
if [ -f "$CACHE_MAPA" ]; then
    TOTAL_NOTAS=$(wc -l < "$CACHE_MAPA")
fi

# 2. Cargar rutas (LRU prioritario + Mapa en RAM)
rutas_usadas=()
count=0

if [ -f "$SESION_RECIENTES" ]; then
    while IFS= read -r ruta && [ $count -lt 10 ]; do
        [ -z "$ruta" ] && continue
        [ -f "$ruta" ] || continue
        rutas_usadas+=("$ruta")
        count=$((count + 1))
    done < "$SESION_RECIENTES"
fi

if [ $count -lt 10 ] && [ -f "$CACHE_MAPA" ]; then
    while IFS='|' read -r md5 base titulo creado modificado ruta && [ $count -lt 10 ]; do
        [ -z "$ruta" ] && continue
        [ -f "$ruta" ] || continue
        
        encontrada=false
        for u in "${rutas_usadas[@]}"; do
            [ "$u" = "$ruta" ] && encontrada=true && break
        done
        
        if [ "$encontrada" = false ]; then
            rutas_usadas+=("$ruta")
            count=$((count + 1))
        fi
    done < "$CACHE_MAPA"
fi

[ ${#rutas_usadas[@]} -eq 0 ] && {
    yad --info --title="Últimas 10 Notas Recientes" --text="No hay notas recientes registradas." --button="Aceptar:0" --center
    exit 0
}

# 3. Construir los botones con el título puro y limpio (sin iconos ni artificios)
campos_yad=()
for ruta in "${rutas_usadas[@]}"; do
    titulo=$(head -n 1 "$ruta" 2>/dev/null | tr -d '|\r\n!')
    [ -z "$titulo" ] && titulo="(Nota vacía)"
    
    if [ ${#titulo} -gt 55 ]; then
        titulo="${titulo:0:52}..."
    fi

    # Etiqueta pura centrada por defecto en el formulario
    label_boton="${titulo}"
    
    cmd_clic="bash -c 'echo \"${ruta}\" > \"${TMP_SELECCION}\"; pkill -f \"yad.*Últimas 10 Notas Recientes\"'"
    
    campos_yad+=("--field=${label_boton}:BTN" "$cmd_clic")
done

# 4. Lanzar formulario limpio, simétrico y de 1 solo clic
yad --form \
    --title="Últimas 10 Notas Recientes" \
    --text="Total de notas en el sistema: <span color='#2ecc71'><b>$TOTAL_NOTAS</b></span>\nClic simple en una nota para abrirla al instante:" \
    --window-icon="notas_bw_10" \
    --width=600 --center --on-top \
    --columns=1 \
    "${campos_yad[@]}" \
    --button="Cerrar:1" >/dev/null 2>&1

# 5. Procesar la selección inmediata del clic
if [ -f "$TMP_SELECCION" ]; then
    RUTA_SELECCIONADA=$(cat "$TMP_SELECCION" | xargs)
    rm -f "$TMP_SELECCION"
    if [ -f "$RUTA_SELECCIONADA" ]; then
        exec "$INIT_CMD" --view "$RUTA_SELECCIONADA"
    fi
fi
