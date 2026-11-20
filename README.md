# Internova – Superstore Sales Data Analysis

## Project Overview

This project was completed as part of the Internova Data Analytics Virtual Internship. It demonstrates an end-to-end data analytics workflow using Python, Microsoft SQL Server and Power BI.

The objective was to analyse Superstore sales data, identify business trends, understand customer purchasing patterns and present findings through interactive dashboards.

## Tools and Technologies

- **Python:** Pandas, Matplotlib, Seaborn
- **Database:** Microsoft SQL Server (T-SQL)
- **Visualisation:** Microsoft Power BI
- **Data Analysis:** Data Cleaning, Exploratory Data Analysis (EDA), KPI Analysis and Customer Segmentation
- **Version Control:** Git and GitHub

## Dataset

The project uses a Superstore sales dataset containing approximately 9,800 sales records and 18 columns.

- Market: United States
- Period: January 2015 – December 2018
- Orders: 4,922
- Customers: 793
- Total Sales: $2,261,537

## Project Workflow

### 1. Data Cleaning and Preparation – Python

- Inspected the dataset and checked data types.
- Converted order and shipping dates into appropriate date formats.
- Handled missing values and removed exact duplicate records.
- Prepared fields for further analysis.
- Performed exploratory data analysis to understand sales patterns.

### 2. SQL Analysis – Microsoft SQL Server

Developed 15 SQL queries to investigate:

- Overall sales performance.
- Yearly sales growth.
- Product category and subcategory performance.
- Regional and state-level sales.
- Top-performing customers and products.
- Customer segments.
- Monthly sales trends and seasonality.
- Shipping methods and delivery performance.
- Customer revenue concentration.

### 3. Power BI Dashboard Development

Created four dashboard pages:

1. **Executive Overview:** Overall sales performance and key metrics.
2. **Sales Analytics:** Product, regional and time-based sales analysis.
3. **Customer Segmentation:** Customer purchasing behaviour and RFM analysis.
4. **Ship Mode Performance:** Shipping methods and delivery trends.

### 4. DAX Measures

Implemented measures including:

- Total Sales
- Total Orders
- Average Order Value
- Previous Year Sales
- Year-on-Year Sales Growth

## Key Findings

- Total sales were approximately $2.26 million across the analysed period.
- Sales increased by 30.64% in 2017 and 20.30% in 2018.
- Technology was the leading product category.
- The West and East regions contributed approximately 61% of sales.
- Consumer customers accounted for approximately 50.76% of sales.
- Standard Class represented approximately 59% of orders.
- The top 20% of customers contributed approximately 48.5% of sales.
- Sales performance showed strong fourth-quarter seasonality.

## Business Value

The analysis provides insights into sales trends, regional performance, customer contribution and shipping patterns. These findings can help businesses identify important customer segments, understand seasonal demand and make better-informed decisions.

## Project Structure

- `python/` – Data cleaning and exploratory analysis.
- `sql/` – SQL queries and business analysis.
- `powerbi/` – Power BI dashboard.
- `screenshots/` – Dashboard images.
- `report/` – Project documentation.

## Author

**Themba Mkhulise**

GitHub: https://github.com/Themba2149  
LinkedIn: https://www.linkedin.com/in/themba-mkhulise-94a720272

---

*Note: The supplied dataset does not contain verified profit or quantity fields. This project therefore focuses on sales analysis and does not present estimated profitability as actual financial results.*
