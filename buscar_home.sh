#!/bin/bash

# Recibir la carpeta donde se buscara
carpeta="${1:-.}"

# Buscar la palabra home en los archivos
find "$carpeta" -type f ! -path '*/.git/*' -print0 |
while IFS= read -r -d '' archivo; do

    if grep -IqFw "home" "$archivo" 2>/dev/null; then
        echo "Encontrado en: $archivo"
    fi

done

