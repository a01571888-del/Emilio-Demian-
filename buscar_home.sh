#!/bin/bash

if [ "$#" -gt 1 ]; then
    echo "Error: debes proporcionar solo una carpeta."
    echo "Uso: bash buscar_home.sh [carpeta]"
    exit 1
fi

carpeta="${1:-.}"

if [ ! -d "$carpeta" ]; then
    echo "Error: la carpeta no existe."
    exit 1
fi

total=0

echo "Buscando la palabra home en: $carpeta"
echo "--------------------------------"

while IFS= read -r -d '' archivo; do

    if grep -IqFw "home" "$archivo" 2>/dev/null; then
        echo "Encontrado en: $archivo"
        total=$((total + 1))
    fi

done < <(find "$carpeta" -type f ! -name "buscar_home.sh" ! -path '*/.git/*' -print0)

echo "--------------------------------"
echo "Total de archivos encontrados: $total"
