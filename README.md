# Notas Zopeck

Una herramienta ligera en la terminal de Linux para buscar, visualizar, editar y autoguardar notas de forma rápida. Diseñada para entornos con recursos limitados, aprovechando RAM (`/dev/shm`) y herramientas eficientes de consola.

## Características
- Búsqueda interactiva ultrarrápida impulsada por `fzf`.
- Interfaz gráfica minimalista con `yad`.
- Caching eficiente utilizando memoria RAM para evitar escrituras innecesarias en disco.
- Empaquetado nativo para Debian/Ubuntu (`.deb`).

## Dependencias
- `bash` (>= 4.0)
- `fzf`
- `yad`
- `awk` / `grep`

## Instalación
Puedes instalar el paquete precompilado descargando la última versión desde los releases o instalando el paquete `.deb`:
```bash
sudo dpkg -i notas-zopeck_1.0-1_amd64.deb
sudo apt-get install -f # para resolver dependencias si fuera necesario
```


## Autor
**Mark**
*Marco A. Rodriguez G.*
*email: zopeck@gmail.com*
