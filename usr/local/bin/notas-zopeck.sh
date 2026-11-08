#!/usr/bin/env bash
# ==============================================================================
# Script: notas-zopeck.sh (v10.6 - Sistema)
# Descripción: Búsqueda y gestión de notas Zopeck con caché en /dev/shm,
#              formulario completo, botones de acción y control robusto de precarga.
# ==============================================================================

NOTAS_DIR="${HOME}/.local/share/notas-zopeck"
FUNCIONES="/usr/share/notas-zopeck/funciones"

# Inicializar entorno de usuario si no existe
source "${FUNCIONES}/inicializa_entorno"
inicializar_entorno_usuario

mkdir -p "$NOTAS_DIR"
CACHE_MAPA="/dev/shm/notas_zopeck_mapa_${USER}.tmp"
SESION_RECIENTES="/tmp/notas_zopeck_recientes_${USER}.tmp"
INIT_CMD="/usr/local/bin/notas-zopeck.sh"

# ------------------------------------------------------------------------------
# 1. Precarga en RAM (/dev/shm)
# ------------------------------------------------------------------------------
source "${FUNCIONES}/generar_mapa_ram"
source "${FUNCIONES}/verificar_o_construir_cache"

if [ "$1" = "--preload" ]; then
    generar_mapa_ram
    exit 0
fi

[ -f "$CACHE_MAPA" ] || generar_mapa_ram

# ------------------------------------------------------------------------------
# 2. Funciones de Carga y Reordenamiento
# ------------------------------------------------------------------------------
source "${FUNCIONES}/cargar_todas_las_notas"
source "${FUNCIONES}/reordenar_resultados_sesion"
source "${FUNCIONES}/verificar_instancia_activa"

# ------------------------------------------------------------------------------
# 3. Interfaz Principal de Listado
# ------------------------------------------------------------------------------
source "${FUNCIONES}/mostrar_lista_yad"

# ------------------------------------------------------------------------------
# 4. Formulario Completo de Búsqueda
# ------------------------------------------------------------------------------
source "${FUNCIONES}/buscar_texto_formulario"

# ------------------------------------------------------------------------------
# 5. Selector de Modo
# ------------------------------------------------------------------------------
case "$1" in
	--ultimas|--recent|ultimas|recent|20)
        titulo_w="Ultimas 20 Notas"
        if pgrep -f "yad --list.*--title=$titulo_w" >/dev/null 2>&1; then
            command -v wmctrl >/dev/null 2>&1 && wmctrl -F -a "$titulo_w" 2>/dev/null
            exit 0
        fi
        verificar_o_construir_cache
        mostrar_lista_yad "$titulo_w" 20 "no" ""
        ;;
    --lastones|--todas|--all|todas|all)
        titulo_w="Todas las Notas"
        if pgrep -f "yad --list.*--title=$titulo_w" >/dev/null 2>&1; then
            command -v wmctrl >/dev/null 2>&1 && wmctrl -F -a "$titulo_w" 2>/dev/null
            exit 0
        fi
        verificar_o_construir_cache
        mostrar_lista_yad "$titulo_w" "todas" "no" ""
        ;;
	--view)
        if [ -f "$2" ]; then
            local ruta_absoluta
            ruta_absoluta=$(readlink -f "$2")
            
            if verificar_instancia_activa "$ruta_absoluta"; then
                exit 0
            fi

            # Registrar en recientes LRU (Pila de sesión)
            grep -v -F "$ruta_absoluta" "$SESION_RECIENTES" 2>/dev/null > "${SESION_RECIENTES}.tmp"
            echo "$ruta_absoluta" > "$SESION_RECIENTES"
            cat "${SESION_RECIENTES}.tmp" >> "$SESION_RECIENTES"
            rm -f "${SESION_RECIENTES}.tmp"

            yad --text-info --wrap \
                --title="Viendo: $(basename "$ruta_absoluta")" \
                --filename="$ruta_absoluta" \
                --width=700 --height=500 --center \
                --button="Cerrar:0"
        fi
        exit 0
        ;;
	--buscar|buscar)
        verificar_o_construir_cache
        buscar_texto_formulario
        ;;
    --backup|--bk|--respaldar|--respaldo|--copia|backup|bk|respaldar|respaldo|copia)
        source "${FUNCIONES}/respaldar_notas_zopeck"
        respaldar_notas_zopeck        
        ;;
    *)
        verificar_o_construir_cache
        buscar_texto_formulario
        ;;
esac

