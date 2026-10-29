#!/bin/bash


procesar_archivo() {
    local archivo="$1"
    local palabra="$2"

    # Contar las apariciones exactas de la palabra en el archivo
    local conteo=$(grep -oiF "$palabra" "$archivo" 2>/dev/null | wc -l)

    if [ "$conteo" -gt 0 ]; then
        local ruta=$(cd "$(dirname "$archivo")" && pwd -P)
        echo "Ubicacion: $ruta/$(basename "$archivo") | Apariciones: $conteo"
        total_archivos=$((total_archivos + 1))
    fi
}



if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Error: Debes proporcionar al menos la palabra a buscar."
    echo "Uso: bash buscar_home.sh <palabra_o_frase> [carpeta]"
    exit 1
fi

palabra="$1"
carpeta="${2:-.}"

if [ ! -d "$carpeta" ]; then
    echo "Error: La carpeta '$carpeta' no existe."
    exit 1
fi

total_archivos=0

echo "Buscando la palabra/frase: '$palabra'"
echo "En la trayectoria: $carpeta"
echo "--------------------------------------------------"

while IFS= read -r -d '' archivo; do
    procesar_archivo "$archivo" "$palabra"
done < <(find "$carpeta" -type f ! -name "buscar_home.sh" ! -path '*/.git/*' -print0)

echo "--------------------------------------------------"
echo "Total de archivos con coincidencias: $total_archivos"

if [ "$total_archivos" -eq 0 ]; then
    echo "No se encontraron coincidencias para: '$palabra'"
fi
