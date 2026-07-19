import kagglehub

# Download latest version
path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")

print("Path to dataset files:", path)

import kagglehub
import shutil
import os

# 1. Descargar y obtener la ruta
path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
print("Archivos descargados en:", path)

# 2. Definir la carpeta de destino en tu proyecto
destino = "./data/raw/"  # Ajusta según la estructura que tengas
os.makedirs(destino, exist_ok=True)

# 3. Copiar todos los archivos .csv
for archivo in os.listdir(path):
    if archivo.endswith('.csv'):
        shutil.copy(os.path.join(path, archivo), destino)
        print(f"✅ Copiado: {archivo}")

print("🎉 ¡Todos los archivos copiados a tu proyecto!")