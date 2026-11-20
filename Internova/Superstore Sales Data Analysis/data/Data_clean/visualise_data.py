from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

script_dir = Path(__file__).resolve().parent
input_path = script_dir / "cleaned_superstore_data.csv"

if not input_path.exists():
    raise FileNotFoundError(
        f"Cleaned data not found at '{input_path}'. Run Cleaned_data.py first."
    )

df = pd.read_csv(input_path, parse_dates=["Order Date", "Ship Date"])

category_sales = df.groupby("Category", as_index=False)["Sales"].sum()
region_sales = df.groupby("Region", as_index=False)["Sales"].sum()
yearly_sales = df.groupby("Order Year", as_index=False)["Sales"].sum()
top_subcategories = (
    df.groupby("Sub-Category", as_index=False)["Sales"]
    .sum()
    .nlargest(5, "Sales")
)

fig, axes = plt.subplots(2, 2, figsize=(15, 10))

sns.barplot(
    data=category_sales, x="Category", y="Sales", color="steelblue", ax=axes[0, 0]
)
axes[0, 0].set_title("Total Sales by Category")
axes[0, 0].tick_params(axis="x", rotation=45)

sns.barplot(
    data=region_sales, x="Region", y="Sales", color="seagreen", ax=axes[0, 1]
)
axes[0, 1].set_title("Total Sales by Region")

axes[1, 0].plot(
    yearly_sales["Order Year"], yearly_sales["Sales"], marker="o", color="red"
)
axes[1, 0].set_title("Yearly Sales Trend")
axes[1, 0].set_ylabel("Total Sales")

sns.barplot(
    data=top_subcategories,
    x="Sales",
    y="Sub-Category",
    order=top_subcategories["Sub-Category"].tolist(),
    color="darkorange",
    ax=axes[1, 1],
)
axes[1, 1].set_title("Top 5 Sub-Categories by Sales")

fig.tight_layout()
plt.show()