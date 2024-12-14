#!/bin/bash

CSV_FILE="pruebaCapacidad.csv"
MODEL_FILE="modelo_entrenado.h5"
PYTHON_SCRIPT="predice.py"

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: El archivo $CSV_FILE no existe."
    exit 1
fi

if [[ ! -f "$MODEL_FILE" ]]; then
    echo "Error: no existe el archivo $MODEL_FILE"
    exit 1
fi

TARGET=$(head -1 "$CSV_FILE" | awk -F',' '{print $NF}')
echo "El objetivo de la predicción es: $TARGET"

FEATURES=$(head -1 "$CSV_FILE" | awk -F',' -v target="$TARGET"
    '{for (i=1; i<=NF; i++) if ($i != target) printf "%s ", $i}')
echo "Características requeridas para la predicción:
    $FEATURES"

echo "Introduce los valores de las siguientes características:"
INPUT_VALUES=()
for feature in $FEATURES; do
    read -p "$feature: " value
    INPUT_VALUES+=("$value")
done

python3 $PYTHON_SCRIPT "$MODEL_FILE" "$TARGET" "${INPUT_VALUES[@]}"
    
