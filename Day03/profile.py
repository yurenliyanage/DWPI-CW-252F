import pandas as pd
import os

# ============================================================
# 1. LOAD DATA
# ============================================================

file_name = "2020_al_data_kaggle_upload_new_old_syllabi.csv"

# Get the folder where this Python file is located
script_folder = os.path.dirname(os.path.abspath(__file__))

# Create full path to CSV
file_path = os.path.join(script_folder, file_name)

# Read CSV
data = pd.read_csv(file_path)


# ============================================================
# 2. BASIC INFORMATION
# ============================================================

print("=" * 60)
print("DATA PROFILING REPORT")
print("=" * 60)

print("\nDataset:")
print(file_name)

print("\nNumber of Rows:", data.shape[0])
print("Number of Columns:", data.shape[1])


# ============================================================
# 3. COLUMN INFORMATION
# ============================================================

print("\n" + "=" * 60)
print("COLUMN INFORMATION")
print("=" * 60)

print(data.info())


# ============================================================
# 4. COLUMN NAMES
# ============================================================

print("\n" + "=" * 60)
print("COLUMN NAMES")
print("=" * 60)

for i, column in enumerate(data.columns, start=1):
    print(f"{i}. {column}")


# ============================================================
# 5. DATA TYPES
# ============================================================

print("\n" + "=" * 60)
print("DATA TYPES")
print("=" * 60)

print(data.dtypes)


# ============================================================
# 6. MISSING VALUES
# ============================================================

print("\n" + "=" * 60)
print("MISSING VALUES")
print("=" * 60)

missing = data.isnull().sum()

missing_percentage = (missing / len(data)) * 100

missing_report = pd.DataFrame({
    "Missing Values": missing,
    "Missing Percentage": missing_percentage
})

print(missing_report)


# ============================================================
# 7. DUPLICATE RECORDS
# ============================================================

print("\n" + "=" * 60)
print("DUPLICATE RECORDS")
print("=" * 60)

duplicate_count = data.duplicated().sum()

print("Number of duplicate rows:", duplicate_count)


# ============================================================
# 8. UNIQUE VALUES
# ============================================================

print("\n" + "=" * 60)
print("UNIQUE VALUES")
print("=" * 60)

for column in data.columns:
    print(f"{column}: {data[column].nunique()} unique values")


# ============================================================
# 9. NUMERICAL SUMMARY
# ============================================================

print("\n" + "=" * 60)
print("NUMERICAL DATA SUMMARY")
print("=" * 60)

print(data.describe())


# ============================================================
# 10. CATEGORICAL DATA SUMMARY
# ============================================================

print("\n" + "=" * 60)
print("CATEGORICAL DATA SUMMARY")
print("=" * 60)

categorical_columns = data.select_dtypes(
    include=["object", "category"]
).columns

for column in categorical_columns:

    print("\n" + "-" * 50)
    print("Column:", column)
    print("-" * 50)

    print(data[column].value_counts(dropna=False).head(20))


# ============================================================
# 11. MINIMUM AND MAXIMUM VALUES
# ============================================================

print("\n" + "=" * 60)
print("MINIMUM AND MAXIMUM VALUES")
print("=" * 60)

numeric_columns = data.select_dtypes(
    include=["number"]
).columns

for column in numeric_columns:

    print(
        f"{column}: "
        f"Min = {data[column].min()}, "
        f"Max = {data[column].max()}"
    )


# ============================================================
# 12. SAMPLE DATA
# ============================================================

print("\n" + "=" * 60)
print("FIRST 10 RECORDS")
print("=" * 60)

print(data.head(10))


# ============================================================
# 13. DATA QUALITY CHECK
# ============================================================

print("\n" + "=" * 60)
print("DATA QUALITY CHECK")
print("=" * 60)

print("\nColumns containing missing values:")

for column in data.columns:

    missing_count = data[column].isnull().sum()

    if missing_count > 0:
        print(
            f"- {column}: "
            f"{missing_count} missing values "
            f"({missing_count / len(data) * 100:.2f}%)"
        )


# ============================================================
# 14. PROFILE COMPLETE
# ============================================================

print("\n" + "=" * 60)
print("DATA PROFILING COMPLETED")
print("=" * 60)