#!/usr/bin/env bash
# ==============================================================================
# Script: notas-zopeck-tray-10.sh
# Descripción: Demonio de bandeja independiente para acceso rápido a 10 notas
# ==============================================================================

# Iniciar notificación permanente en el tray
exec yad --notification \
    --image="notas_bw_10" \
    --text="Notas Zopeck (Últimas 10 Recientes)
Haga clic aqui para mostrar la lista y
ver alguna..." \
    --command="/usr/local/bin/notas-zopeck-recientes.sh"
