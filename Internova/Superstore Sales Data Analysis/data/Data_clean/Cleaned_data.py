from pathlib import Path

import pandas as pd

script_dir = Path(__file__).resolve().parent
input_path = script_dir.parent / "train.csv"
output_path = script_dir / "cleaned_superstore_data.csv"

# Read the existing header and correctly handle commas inside quoted values.
df = pd.read_csv(input_path, dtype={"Postal Code": "string"})

# Convert dates (format is DD/MM/YYYY).
df["Order Date"] = pd.to_datetime(
    df["Order Date"], format="%d/%m/%Y", errors="coerce"
)
df["Ship Date"] = pd.to_datetime(
    df["Ship Date"], format="%d/%m/%Y", errors="coerce"
)

# Ensure Sales is numeric.
df["Sales"] = pd.to_numeric(df["Sales"], errors="coerce")

# Drop rows without critical information and remove duplicate rows.
df = df.dropna(subset=["Order ID", "Sales"])
df = df.drop_duplicates()

# Add time-based features for analysis.
df["Order Year"] = df["Order Date"].dt.year
df["Order Month"] = df["Order Date"].dt.month
df["Order Month Name"] = df["Order Date"].dt.month_name()

# Save cleaned data alongside this script.
df.to_csv(output_path, index=False)
print(f"Data cleaning complete. Saved to '{output_path}'")