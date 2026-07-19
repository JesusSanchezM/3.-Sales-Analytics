import pandas as pd
from sqlalchemy import create_engine
import os

# ===================== CONFIGURATION =====================
DB_USER = "jesussanchez"
DB_PASSWORD = ""  
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "olist_db"

# Path to your CSV files (adjust if necessary)
RAW_DATA_PATH = "./data/raw/"

# ===================== CREATE CONNECTION =====================
engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')

# ===================== FILE DICTIONARY =====================
# (filename -> table name in PostgreSQL)
files = {
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

# ===================== LOAD DATA =====================
print("⏳ Connecting to PostgreSQL...")
print("📤 Loading data...")

for file, table in files.items():
    file_path = os.path.join(RAW_DATA_PATH, file)
    if not os.path.exists(file_path):
        print(f"⚠️ File not found: {file_path}")
        continue
    print(f"   📥 {file} -> {table} ...")
    df = pd.read_csv(file_path)
    df.to_sql(table, engine, if_exists='replace', index=False)
    print(f"      ✅ {len(df)} records inserted.")

print("🎉 All data successfully loaded to PostgreSQL!")