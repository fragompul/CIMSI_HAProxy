import sys
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.optimizers import Adam
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

if len(sys.argv) != 4:
    print("Uso: python3 entrenar_red_neuronal.py <csv_file> <target_column> <output_model>")
    sys.exit(1)

csv_file = sys.argv[1]
target_column = sys.argv[2]
output_model = sys.argv[3]

data = pd.read_csv(csv_file)

if target_column not in data.columns:
    print(f"Error: La columna objetivo '{target_column}' no existe en el archivo csv")
    sys.exit(1)

X = data.drop(columns=[target_column]).values
y = data[target_column].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

model = Sequential([
    Dense(64, input_dim=X_train.shape[1], activation='relu'),
    Dense(32, activation='relu'),
    Dense(1, activation='linear')
])

model.compile(optimizer=Adam(learning_rate=0.001), loss='mean_squared_error', metrics=['mae'])

model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=50, batch_size=32, verbose=1)

model.save(output_model)
print(f"Modelo entrenado guardado en: {output_model}")
