import pandas as pd
import os

# CSV file name
file_name = "2020_al_data_kaggle_upload_new_old_syllabi.csv"

# Get the folder where this Python script is located
script_folder = os.path.dirname(os.path.abspath(__file__))

# Create the full CSV path
file_path = os.path.join(script_folder, file_name)

# Extract
data = pd.read_csv(file_path)

print("Number of rows:", len(data))
print("Number of columns:", len(data.columns))

print("\nColumn names:")
print(data.columns.tolist())

print("\nFirst 5 records:")
print(data.head())