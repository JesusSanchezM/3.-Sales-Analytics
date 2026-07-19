import pandas as pd
from sqlalchemy import create_engine
import os

# ===================== CONFIGURACIÓN =====================
DB_USER = "jesussanchez"
DB_PASSWORD = ""  
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "olist_db"

# Ruta donde están tus CSVs (ajusta si es necesario)
RAW_DATA_PATH = "./data/raw/"

# ===================== CREAR CONEXIÓN =====================
engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')

# ===================== DICCIONARIO DE ARCHIVOS =====================
# (nombre del archivo -> nombre de la tabla en PostgreSQL)
archivos = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation"
}

# ===================== CARGAR DATOS =====================
print("⏳ Conectando a PostgreSQL...")
print("📤 Cargando datos...")

for archivo, tabla in archivos.items():
    ruta = os.path.join(RAW_DATA_PATH, archivo)
    if not os.path.exists(ruta):
        print(f"⚠️ Archivo no encontrado: {ruta}")
        continue
    print(f"   📥 {archivo} -> {tabla} ...")
    df = pd.read_csv(ruta)
    # Si la tabla ya existe, la reemplazamos
    df.to_sql(tabla, engine, if_exists='replace', index=False)
    print(f"      ✅ {len(df)} registros insertados.")

print("🎉 ¡Todos los datos cargados exitosamente a PostgreSQL!")