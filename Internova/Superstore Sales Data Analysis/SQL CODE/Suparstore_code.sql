
-- =========================================================
-- SUPERSTORE TRANSACTIONAL SALES ANALYSIS
-- Database: bcb-extdev
-- Schema: dbo
-- Table: Superstore_transactional_sales
-- SQL Dialect: Microsoft SQL Server (T-SQL)
-- =========================================================

USE [bcb-extdev];
GO

-- =========================================================
-- Q1: OVERALL BUSINESS KPIs
-- =========================================================

SELECT
    ROUND(SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) /
        NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Average_Order_Value
FROM [dbo].[Superstore_transactional_sales];


-- =========================================================
-- Q2: SALES BY YEAR WITH YEAR-OVER-YEAR GROWTH
-- =========================================================

WITH yearly_sales AS (
    SELECT
        Order_Year,
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) AS Total_Sales
    FROM [dbo].[Superstore_transactional_sales]
    GROUP BY Order_Year
)
SELECT
    Order_Year,
    ROUND(Total_Sales, 2) AS Sales,
    ROUND(
        100.0 * (
            Total_Sales -
            LAG(Total_Sales) OVER (ORDER BY Order_Year)
        ) /
        NULLIF(
            LAG(Total_Sales) OVER (ORDER BY Order_Year),
            0
        ),
        2
    ) AS YoY_Growth_Percentage
FROM yearly_sales
ORDER BY Order_Year;


-- =========================================================
-- Q3: SALES BY CATEGORY AND SUB-CATEGORY
-- =========================================================

SELECT
    Category,
    Sub_Category,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales,
    ROUND(
        100.0 * SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) /
        NULLIF((
            SELECT SUM(TRY_CONVERT(DECIMAL(18,2), Sales))
            FROM [dbo].[Superstore_transactional_sales]
        ), 0),
        2
    ) AS Sales_Percentage
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q4: SALES BY REGION
-- =========================================================

SELECT
    Region,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) /
        NULLIF(COUNT(DISTINCT Order_ID), 0),
        2
    ) AS Average_Order_Value
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Region
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q5: TOP 10 STATES BY SALES
-- =========================================================

SELECT TOP 10
    State,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales
FROM [dbo].[Superstore_transactional_sales]
GROUP BY State
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q6: TOP 10 CUSTOMERS BY SALES
-- =========================================================

SELECT TOP 10
    Customer_ID,
    Customer_Name,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q7: TOP 10 PRODUCTS BY SALES
-- =========================================================

SELECT TOP 10
    Product_ID,
    Product_Name,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q8: CUSTOMER SEGMENT PERFORMANCE
-- =========================================================

SELECT
    Segment,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales,
    ROUND(
        100.0 * SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) /
        NULLIF((
            SELECT SUM(TRY_CONVERT(DECIMAL(18,2), Sales))
            FROM [dbo].[Superstore_transactional_sales]
        ), 0),
        2
    ) AS Sales_Percentage
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Segment
ORDER BY Total_Sales DESC;


-- =========================================================
-- Q9: SHIP MODE AND DELIVERY PERFORMANCE
-- =========================================================

SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(
        AVG(CAST(
            DATEDIFF(DAY, Order_Date, Ship_Date) AS DECIMAL(18,2)
        )),
        2
    ) AS Average_Delivery_Days,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Ship_Mode
ORDER BY Total_Orders DESC;


-- =========================================================
-- Q10: MONTHLY SALES SEASONALITY
-- AVERAGE MONTHLY SALES ACROSS AVAILABLE YEARS
-- =========================================================

WITH monthly_sales AS (
    SELECT
        Order_Year,
        Order_Month,
        Order_Month_Name,
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) AS Monthly_Sales
    FROM [dbo].[Superstore_transactional_sales]
    GROUP BY
        Order_Year,
        Order_Month,
        Order_Month_Name
)
SELECT
    Order_Month AS Month_Number,
    Order_Month_Name AS Month_Name,
    ROUND(AVG(Monthly_Sales), 2) AS Average_Monthly_Sales
FROM monthly_sales
GROUP BY
    Order_Month,
    Order_Month_Name
ORDER BY Order_Month;


-- =========================================================
-- Q11: CUSTOMER REVENUE CONCENTRATION
-- TOP 20% OF CUSTOMERS' SHARE OF TOTAL SALES
-- =========================================================

WITH customer_totals AS (
    SELECT
        Customer_ID,
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) AS Customer_Sales
    FROM [dbo].[Superstore_transactional_sales]
    GROUP BY Customer_ID
),
customer_quintiles AS (
    SELECT
        Customer_ID,
        Customer_Sales,
        NTILE(5) OVER (
            ORDER BY Customer_Sales DESC
        ) AS Customer_Group
    FROM customer_totals
)
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN Customer_Group = 1 THEN Customer_Sales
                ELSE 0
            END
        ) /
        NULLIF(SUM(Customer_Sales), 0),
        2
    ) AS Top_20_Percent_Customer_Sales_Share
FROM customer_quintiles;


-- =========================================================
-- Q12: CATEGORY SALES BY REGION
-- =========================================================

SELECT
    Region,
    Category,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;


-- =========================================================
-- Q13: MONTHLY SALES BY REGION
-- =========================================================

SELECT
    Region,
    Order_Month AS Month_Number,
    Order_Month_Name AS Month_Name,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Sales
FROM [dbo].[Superstore_transactional_sales]
GROUP BY
    Region,
    Order_Month,
    Order_Month_Name
ORDER BY Region, Month_Number;


-- =========================================================
-- Q14: TOP 5 CUSTOMERS BY TOTAL SPENDING
-- =========================================================

SELECT TOP 5
    Customer_ID,
    Customer_Name,
    Segment,
    COUNT(DISTINCT Order_ID) AS Order_Count,
    ROUND(
        SUM(TRY_CONVERT(DECIMAL(18,2), Sales)), 2
    ) AS Total_Spent
FROM [dbo].[Superstore_transactional_sales]
GROUP BY
    Customer_ID,
    Customer_Name,
    Segment
ORDER BY Total_Spent DESC;


-- =========================================================
-- Q15: CUSTOMER SEGMENT MARKET SHARE
-- =========================================================

SELECT
    Segment,
    ROUND(
        100.0 * SUM(TRY_CONVERT(DECIMAL(18,2), Sales)) /
        NULLIF((
            SELECT SUM(TRY_CONVERT(DECIMAL(18,2), Sales))
            FROM [dbo].[Superstore_transactional_sales]
        ), 0),
        2
    ) AS Market_Share_Percentage
FROM [dbo].[Superstore_transactional_sales]
GROUP BY Segment
ORDER BY Market_Share_Percentage DESC;


-- =========================================================
-- END OF SALES ANALYSIS
-- =========================================================
