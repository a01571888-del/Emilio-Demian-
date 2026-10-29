#!/bin/bash

# 1. Verificar cantidad de argumentos
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Error: Debes proporcionar al menos la palabra a buscar."
    echo "Uso: bash buscar_home.sh <palabra_o_frase> [carpeta]"
    exit 1
fi

# 2. Asignación de variables por argumentos
palabra="$1"
carpeta="${2:-.}"

# 3. Validar existencia del directorio
if [ ! -d "$carpeta" ]; then
    echo "Error: La carpeta '$carpeta' no existe."
    exit 1
fi

total_archivos=0

echo "Buscando la palabra/frase: '$palabra'"
echo "En la trayectoria: $carpeta"
echo "--------------------------------------------------"

# 4. Recorrer archivos excluyendo la carpeta .git y el propio script
while IFS= read -r -d '' archivo; do

    # Contar las apariciones exactas de la palabra en el archivo
    conteo=$(grep -oiF "$palabra" "$archivo" 2>/dev/null | wc -l)

    if [ "$conteo" -gt 0 ]; then
        ruta=$(cd "$(dirname "$archivo")" && pwd -P)
        echo "Ubicacion: $ruta/$(basename "$archivo") | Apariciones: $conteo"
        total_archivos=$((total_archivos + 1))
    fi

done < <(find "$carpeta" -type f ! -name "buscar_home.sh" ! -path '*/.git/*' -print0)

# 5. Resumen de resultados
echo "--------------------------------------------------"
echo "Total de archivos con coincidencias: $total_archivos"

if [ "$total_archivos" -eq 0 ]; then
    echo "No se encontraron coincidencias para: '$palabra'"
fi
