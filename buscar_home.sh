#!/bin/bash

# Validar la cantidad de argumentos
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Error: escribe una palabra y opcionalmente una carpeta."
    echo "Uso: bash buscar_home.sh palabra [carpeta]"
    exit 1
fi

# Recibir los argumentos
palabra="$1"
carpeta="${2-/}"

# Verificar que exista la carpeta
if [ ! -d "$carpeta" ]; then
    echo "Error: la carpeta no existe."
    exit 1
fi

# Inicializar contador
total=0

echo "Buscando: $palabra"
echo "Carpeta: $carpeta"
echo "--------------------------------"

# Recorrer archivos y subcarpetas
while IFS= read -r -d '' archivo; do

    if grep -IqFw -- "$palabra" "$archivo" 2>/dev/null; then
        echo "Encontrado en: $archivo"
        total=$((total + 1))
    fi

done < <(find "$carpeta" -type d -name .git -prune -o -type f ! -name "buscar_home.sh" -print0 2>/dev/null)

echo "--------------------------------"
echo "Total de archivos encontrados: $total"

