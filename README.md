# 📊 Consumer Goods SQL Analysis

An end-to-end **SQL Business Analysis Project** developed using the
**AtliQ Hardware** consumer goods dataset. This project answers **10
real-world business requests** from stakeholders using SQL and
demonstrates analytical thinking, problem solving, and business
reporting skills.

------------------------------------------------------------------------

# 🏢 Company Overview

**AtliQ Hardware** is an imaginary consumer goods company operating
across multiple global markets. The company sells products through
retailers, distributors, and direct channels and relies on data-driven
decisions to improve sales, customer relationships, pricing,
manufacturing, and product strategy.

------------------------------------------------------------------------

# 🔎 Problem Statement

Business stakeholders required answers to multiple analytical questions
regarding customers, products, manufacturing costs, discounts, channels,
and sales trends. Instead of relying on spreadsheets, these questions
were answered using SQL against a relational database.

------------------------------------------------------------------------

# 🎯 Project Objective

Develop optimized SQL solutions to solve business problems and generate
insights that support better business decisions.

------------------------------------------------------------------------

# 🛢️ Database Overview

Tables used:

-   dim_customer
-   dim_product
-   fact_sales_monthly
-   fact_gross_price
-   fact_manufacturing_cost
-   fact_pre_invoice_deductions

Fiscal Year: **September -- August**

------------------------------------------------------------------------

# 🛠 SQL Concepts Used

-   SELECT
-   WHERE
-   GROUP BY
-   ORDER BY
-   DISTINCT
-   INNER JOIN
-   Common Table Expressions (CTEs)
-   Subqueries
-   Aggregate Functions
-   CASE WHEN
-   Window Functions
-   DENSE_RANK()
-   COUNT(), SUM(), AVG(), ROUND()

------------------------------------------------------------------------

# 📋 Business Questions Solved

The following table summarizes the business requests addressed in this project and the primary SQL concepts used to solve each one.

| No. | Business Requirement | Primary SQL Concepts Used |
|:---:|----------------------|---------------------------|
| 1 | Identify the markets where **Atliq Exclusive** operates in the **APAC** region. | `WHERE`, `DISTINCT` |
| 2 | Calculate the percentage increase in unique products sold in **FY2021** compared to **FY2020**. | `CTE`, `COUNT()`, `ROUND()` |
| 3 | Generate a report showing the unique product count for each product segment. | `GROUP BY`, `COUNT()` |
| 4 | Determine which product segment experienced the highest increase in unique products between FY2020 and FY2021. | `JOIN`, `CTE`, `GROUP BY` |
| 5 | Identify the products with the **highest** and **lowest** manufacturing costs. | `JOIN`, `MIN()`, `MAX()` |
| 6 | Retrieve the **Top 5 customers** receiving the highest average pre-invoice discount percentage in the Indian market for FY2021. | `JOIN`, `AVG()`, `ORDER BY`, `LIMIT` |
| 7 | Calculate the monthly **Gross Sales Amount** for **Atliq Exclusive** to analyze monthly sales performance. | `JOIN`, `SUM()`, `GROUP BY`, `MONTHNAME()` |
| 8 | Find the quarter in **FY2020** with the highest total sold quantity. | `CASE`, `SUM()`, `GROUP BY` |
| 9 | Determine which sales channel contributed the highest gross sales in FY2021 and calculate its percentage contribution. | `Window Functions`, `SUM()`, `CTE` |
| 10 | Retrieve the **Top 3 products** in each division based on total sold quantity for FY2021. | `DENSE_RANK()`, `CTE`, `Window Functions` |

------------------------------------------------------------------------

# ⚙️ Project Workflow

Business Requirement → Understand Data → Write SQL Queries → Validate
Results → Generate Insights → Support Decision Making

------------------------------------------------------------------------

# 📂 Repository Contents

``` text
consumer-goods-sql-analysis
│── README.md
│── consumer_goods_business_analysis.sql
│── consumer_goods_sql_project.pdf
└── consumer_goods_business_requirements.pdf
```

------------------------------------------------------------------------

# 💡 Key Business Insights

- 📈 The number of unique products increased from **245 in FY2020** to **334 in FY2021**, representing a **36.33% growth**, indicating significant product portfolio expansion.

- 🌏 **Atliq Exclusive** operates across **8 APAC markets**, highlighting the company's strong regional presence.

- 🏭 The **Notebook** segment recorded the highest increase in unique products between FY2020 and FY2021, reflecting increased investment in this product category.

- 💰 Manufacturing costs ranged from **₹0.89** to **₹240.54**, revealing a wide variation in production expenses across products.

- 🎯 The **Retailer** channel contributed approximately **73%** of total gross sales in FY2021, making it the company's most important revenue channel.

- 📅 Gross sales peaked during **November and December**, suggesting strong seasonal demand driven by festive and year-end sales.

- 🇮🇳 Customers in the **Indian market** received the highest average pre-invoice discount percentages, demonstrating the company's focus on market expansion and customer acquisition.

- 🏆 Several products consistently ranked among the **Top 3 best-selling products** within their divisions, providing clear candidates for future marketing and inventory prioritization.
------------------------------------------------------------------------

# 📝 Recommendations

-   Expand high-performing product segments.
-   Review discount strategy for profitability.
-   Focus marketing on high-performing channels.
-   Monitor seasonal demand patterns for inventory planning.

------------------------------------------------------------------------

# 🚀 Challenges Faced

-   Writing readable SQL using CTEs.
-   Handling aggregations across multiple tables.
-   Choosing the correct join strategy.
-   Ranking products within each division.

------------------------------------------------------------------------

# 📈 Skills Demonstrated

-   SQL
-   MySQL
-   Data Analysis
-   Business Analytics
-   Analytical Thinking
-   Data Exploration
-   KPI Reporting
-   Problem Solving

------------------------------------------------------------------------

# 📚 What I Learned

-   Translating business questions into SQL.
-   Writing optimized analytical queries.
-   Using window functions for ranking.
-   Working with relational databases.
-   Communicating findings through business insights.

------------------------------------------------------------------------

# 👨‍💻 Author

**Anshul Saini**

Aspiring Data Analyst

**Skills:** SQL • Power BI • Python • Excel • MySQL

------------------------------------------------------------------------

# ⭐ If you found this project useful, consider giving it a star!
