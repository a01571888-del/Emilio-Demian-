#!/bin/bash

# Validar la cantidad de argumentos
if [ "$#" -ne 2 ]; then
    echo "Error: debes ingresar exactamente 2 argumentos."
    echo "Uso: bash buscar_home.sh palabra carpeta"
    exit 1
fi

# Validar que la palabra no este vacia
if [ -z "$1" ]; then
    echo "Error: debes escribir una palabra o frase."
    exit 1
fi

# Validar que la carpeta exista
if [ ! -d "$2" ]; then
    echo "Error: la carpeta indicada no existe."
    exit 1
fi

# Recibir los argumentos
palabra="$1"
carpeta="$2"

# Inicializar contador
total_archivos=0

echo "Buscando la palabra/frase: '$palabra'"
echo "En la trayectoria: $carpeta"
echo "------------------------------------------------"

# Funcion para procesar cada archivo
procesar_archivo() {

    local archivo="$1"

    # Contar apariciones de la palabra o frase
    local conteo
    conteo=$(grep -oiF -- "$palabra" "$archivo" 2>/dev/null | wc -l)

    # Mostrar archivos con coincidencias
    if [ "$conteo" -gt 0 ]; then

        local ruta
        ruta=$(cd "$(dirname "$archivo")" && pwd -P)

        echo "Ubicacion: $ruta/$(basename "$archivo") | Apariciones: $conteo"

        total_archivos=$((total_archivos + 1))
    fi
}

# Buscar en la carpeta y sus subcarpetas
while IFS= read -r -d '' archivo; do
    procesar_archivo "$archivo"
done < <(find "$carpeta" -type d -name .git -prune -o -type f -print0 2>/dev/null)

echo "------------------------------------------------"
echo "Total de archivos con coincidencias: $total_archivos"

# Mensaje si no hay resultados
if [ "$total_archivos" -eq 0 ]; then
    echo "No se encontraron coincidencias."
fi

