#!/bin/bash

if [ "$#" -gt 2 ]; then
    echo "Error: debes proporcionar como maximo dos argumentos."
    echo "Uso: bash buscar_home.sh [palabra] [carpeta]"
    exit 1
fi

palabra="${1:-home}"
carpeta="${2:-.}"

if [ ! -d "$carpeta" ]; then
    echo "Error: la carpeta no existe."
    exit 1
fi

total=0

echo "Buscando la palabra '$palabra' en: $carpeta"
echo "--------------------------------"

while IFS= read -r -d '' archivo; do

    if grep -IqFw "$palabra" "$archivo" 2>/dev/null; then
        ruta=$(cd "$(dirname "$archivo")" && pwd -P)
        echo "Encontrado en: $ruta/$(basename "$archivo")"
        total=$((total + 1))
    fi

done < <(find "$carpeta" -type f ! -name "buscar_home.sh" ! -path '*/.git/*' -print0)

echo "--------------------------------"
echo "Total de archivos encontrados: $total"

if [ "$total" -eq 0 ]; then
    echo "No se encontraron archivos con la palabra: $palabra"
fi
