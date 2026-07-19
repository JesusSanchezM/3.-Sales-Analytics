import kagglehub
import shutil
import os

# 1. Download and get the path
path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
print("Files downloaded to:", path)

# 2. Define the destination folder in your project
destination = "./data/raw/"
os.makedirs(destination, exist_ok=True)

# 3. Copy all .csv files
for file in os.listdir(path):
    if file.endswith('.csv'):
        shutil.copy(os.path.join(path, file), destination)
        print(f"✅ Copied: {file}")

print("🎉 All files copied to your project!")