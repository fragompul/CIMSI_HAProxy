import sys
import numpy as np
import tensorflow as tf

if len(sys.argv) < 4:
    print("Uso: python3 predice.py <modelo> <target> <valores...>")
    sys.exit(1)

model_path = sys.argv[1]
target = sys.argv[2]
input_values = list(map(float, sys.argv[3:]))

try:
    model = tf.keras.models.load_model(model_path)
except Exception as e:
    print(f"Error al cargar el modelo: {e}")
    sys.exit(1)

input_array = np.array(input_values).reshape(1, -1)

try:
    prediction = model.predict(input_array)
    print(f"Predicción para el target '{target}': {prediction[0][0]}")
except Exception as e:
    print(f"Error durante la predicción: {e}")
    sys.exit(1)
