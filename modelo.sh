#!/bin/bash

CSV_FILE="pruebaCapacidad.csv"
PYTHON_SCRIPT="entrenar_red_neuronal.py"
OUTPUT_MODEL="modelo_entrenado.h5"

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: no existe el archivo $CSV_FILE"
    exit 1
fi

OPTIONS=$(head -1 "$CSV_FILE" | awk -F',' '{print $(NF-2), $(NF-1), $NF}')
echo "Por favor, selecciona la columna objetivo:"
select TARGET in $OPTIONS; do
    if [[ -n "$TARGET" ]]; then
        echo "Has seleccionado la columna: $TARGET"
        break
    else
        echo "Inténtalo de nuevo, seleccionando una de las tres columnas"
    fi
done

# Ejecutar entrenar_red_neuronal.py:
echo "Entrenando la red neuronal con la columna objetivo: $TARGET..."
python3 $PYTHON_SCRIPT "$CSV_FILE" "$TARGET" "$OUTPUT_MODEL"

if [[ $? -eq 0 ]]; then
    echo "Entrenamiento completado"
    echo "Modelo guardado en: $OUTPUT_MODEL"
else
    echo "Error durante el entrenamiento"
fi

