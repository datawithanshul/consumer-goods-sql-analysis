/*
===============================================================================
                           CONSUMER GOODS SQL ANALYSIS
===============================================================================

Project Name : Consumer Goods SQL Analysis
Author       : Anshul Saini
Database     : AtliQ Hardware
SQL Dialect  : MySQL

===============================================================================
Project Description
===============================================================================

This project presents SQL solutions to ten real-world business requirements
provided by business stakeholders of AtliQ Hardware. The primary objective is
to analyze customer behavior, product performance, manufacturing costs,
discount strategies, sales trends, and channel performance using SQL.

The project demonstrates how SQL can be used to transform raw business data
into meaningful insights that support data-driven decision making.

===============================================================================
Skills Demonstrated
===============================================================================

• SQL Query Writing
• Data Cleaning & Exploration
• Business Analysis
• Data Aggregation
• Joins
• Common Table Expressions (CTEs)
• Window Functions
• Aggregate Functions
• Ranking Functions
• Subqueries
• Analytical Thinking
• Business Problem Solving

===============================================================================
Database Tables Used
===============================================================================

• dim_customer
• dim_product
• fact_sales_monthly
• fact_gross_price
• fact_manufacturing_cost
• fact_pre_invoice_deductions

===============================================================================
*/

/*
===============================================================================
Question 1 : Markets where "Atliq Exclusive" operates in the APAC Region
===============================================================================

Business Requirement
--------------------
Provide the list of markets in which customer "Atliq Exclusive"
operates its business in the APAC region.

Business Objective
------------------
Identify all unique markets in the APAC region where Atliq Exclusive
conducts its business operations. This information helps stakeholders
understand the company's regional presence and market coverage.

SQL Concepts Used
-----------------
• WHERE Clause
• DISTINCT
• Filtering
• Data Exploration

===============================================================================
SQL Solution
===============================================================================
*/

SELECT DISTINCT market
FROM dim_customer
WHERE customer = 'Atliq Exclusive'
  AND region = 'APAC';


/*
===============================================================================
Explanation
===============================================================================

1. The WHERE clause filters the records to include only the customer
   "Atliq Exclusive" operating in the APAC region.

2. DISTINCT ensures that duplicate market names are removed.

3. The final output returns only the unique markets where the customer
   conducts business.

===============================================================================
Expected Output Columns
===============================================================================

market

===============================================================================
*/

/*
===============================================================================
Question 2 : Percentage Increase in Unique Products (FY2021 vs FY2020)
===============================================================================

Business Requirement
--------------------
Calculate the percentage increase in unique products sold in
Fiscal Year 2021 compared to Fiscal Year 2020.

Business Objective
------------------
Analyze the company's product portfolio growth by comparing the
number of unique products sold in FY2020 and FY2021. This helps
business stakeholders understand how much the product catalog
expanded over the two fiscal years.

Expected Output
---------------
• unique_products_2020
• unique_products_2021
• percentage_change

SQL Concepts Used
-----------------
• Common Table Expression (CTE)
• COUNT(DISTINCT)
• Aggregate Functions
• ROUND()
• Scalar Subquery

===============================================================================
SQL Solution
===============================================================================
*/

SELECT COUNT(DISTINCT product)
FROM dim_product;

WITH CTE2 AS (
SELECT
        COUNT(DISTINCT product_code) AS unique_products_2020,
        (
            SELECT COUNT(DISTINCT product_code)
            FROM fact_sales_monthly
            WHERE fiscal_year = 2021
        ) AS unique_products_2021
FROM fact_sales_monthly
WHERE fiscal_year = 2020
)

SELECT *,
ROUND(
        (
            (unique_products_2021 - unique_products_2020)
            * 100
            / unique_products_2020
        ),
        2
) AS percentage_change
FROM CTE2;


/*
===============================================================================
Explanation
===============================================================================

1. The query first counts the number of unique products sold during
   Fiscal Year 2020.

2. A scalar subquery is used to calculate the number of unique
   products sold during Fiscal Year 2021.

3. Both values are stored inside a Common Table Expression (CTE)
   named CTE2.

4. Finally, the percentage increase is calculated using the formula:

   ((FY2021 Products - FY2020 Products) × 100)
   --------------------------------------------
              FY2020 Products

5. The ROUND() function is used to display the result up to
   two decimal places.

===============================================================================
Expected Output Columns
===============================================================================

• unique_products_2020
• unique_products_2021
• percentage_change

===============================================================================
*/

/*
===============================================================================
Question 3 : Unique Product Count by Segment
===============================================================================

Business Requirement
--------------------
Provide a report showing the total number of unique products available
under each product segment. The final output should contain the
following fields:

• Segment
• Product Count

Business Objective
------------------
Analyze the distribution of products across different business segments.
This helps stakeholders understand which segments have the largest
product portfolio and identify areas for potential expansion or
optimization.

Expected Output
---------------
• segment
• product_count

SQL Concepts Used
-----------------
• GROUP BY
• COUNT()
• Aggregate Functions
• ORDER BY

===============================================================================
SQL Solution
===============================================================================
*/

SELECT COUNT(DISTINCT(segment))
FROM dim_product;

SELECT
     segment,
     COUNT(segment) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;


/*
===============================================================================
Explanation
===============================================================================

1. The first query counts the total number of unique product segments
   available in the dataset.

2. The second query groups the data based on the 'segment' column.

3. COUNT(segment) calculates the total number of products available
   within each segment.

4. GROUP BY creates one record for every unique product segment.

5. ORDER BY sorts the result in descending order so that the segment
   with the highest number of products appears at the top of the report.

===============================================================================
Expected Output Columns
===============================================================================

• segment
• product_count

===============================================================================
Business Insight
===============================================================================

This report provides a clear overview of the product distribution across
different business segments. It enables business stakeholders to identify
segments with a broader product portfolio, evaluate product diversity,
and support strategic decisions related to product development,
inventory planning, and market expansion.

===============================================================================
*/

/*
===============================================================================
Question 4 : Segment-wise Increase in Unique Products (FY2021 vs FY2020)
===============================================================================

Business Requirement
--------------------
Identify which product segment experienced the highest increase in
unique products between Fiscal Year 2020 and Fiscal Year 2021.

The final output should contain the following fields:

• Segment
• Product_Count_2020
• Product_Count_2021
• Difference

Business Objective
------------------
Compare product growth across different business segments to determine
which segment expanded the most between FY2020 and FY2021. This helps
business stakeholders understand product portfolio growth and identify
high-growth business segments.

Expected Output
---------------
• Segment
• Product_Count_2020
• Product_Count_2021
• Difference

SQL Concepts Used
-----------------
• INNER JOIN
• Common Table Expressions (CTEs)
• GROUP BY
• COUNT(DISTINCT)
• ORDER BY

===============================================================================
SQL Solution
===============================================================================
*/

SELECT COUNT(DISTINCT(segment))
FROM dim_product;

WITH CTE4 AS (
     SELECT
     dp.segment AS SEGMENT,
     COUNT(DISTINCT fsm.product_code) AS product_count_2020,
     fsm.fiscal_year
     FROM fact_sales_monthly AS fsm
     JOIN dim_product AS dp
          ON fsm.product_code = dp.product_code
     WHERE fiscal_year = 2020
     GROUP BY dp.segment
     ORDER BY product_count_2020 DESC
),

CTE41 AS (
     SELECT
     dp.segment AS SEGMENT1,
     COUNT(DISTINCT fsm.product_code) AS product_count_2021,
     fsm.fiscal_year
     FROM fact_sales_monthly AS fsm
     JOIN dim_product AS dp
          ON fsm.product_code = dp.product_code
     WHERE fiscal_year = 2021
     GROUP BY dp.segment
     ORDER BY product_count_2021 DESC
)

SELECT
     SEGMENT,
     CTE4.product_count_2020,
     CTE41.product_count_2021,
     (CTE41.product_count_2021 - CTE4.product_count_2020) AS Difference

FROM CTE4
JOIN CTE41
     ON CTE4.SEGMENT = CTE41.SEGMENT1

ORDER BY Difference DESC;


/*
===============================================================================
Explanation
===============================================================================

1. The first CTE (CTE4) calculates the number of unique products
   available in each product segment during Fiscal Year 2020.

2. The second CTE (CTE41) performs the same calculation for
   Fiscal Year 2021.

3. Both CTEs are joined using the Segment column to compare
   product counts across the two fiscal years.

4. The Difference column is calculated by subtracting the FY2020
   product count from the FY2021 product count.

5. Finally, the results are sorted in descending order of the
   Difference column so that the segment with the highest product
   growth appears at the top.

===============================================================================
Business Insight
===============================================================================

This analysis highlights the product segments that experienced the
greatest expansion between FY2020 and FY2021. Understanding segment-wise
growth helps management evaluate product strategy, prioritize investment,
and identify business areas driving portfolio expansion.

===============================================================================
Interview Perspective
===============================================================================

Why did we use two CTEs?

Two separate CTEs were created to independently calculate the unique
product count for FY2020 and FY2021. This simplifies the comparison by
allowing the results from each fiscal year to be joined on the Segment
column, making the final difference calculation easy to understand and
maintain.

Why was COUNT(DISTINCT product_code) used?

COUNT(DISTINCT product_code) ensures that each product is counted only
once within a segment, preventing duplicate sales records from inflating
the product count.

===============================================================================
*/

/*
===============================================================================
Question 5 : Products with the Highest and Lowest Manufacturing Costs
===============================================================================

Business Requirement
--------------------
Identify the products that have the highest and the lowest manufacturing
costs.

The final output should contain the following fields:

• Product Code
• Product
• Manufacturing Cost

Business Objective
------------------
Analyze the manufacturing cost of products to identify cost extremes.
This analysis helps stakeholders understand which products are the most
and least expensive to manufacture, supporting pricing strategies,
cost optimization, and profitability analysis.

Expected Output
---------------
• product_code
• product
• manufacturing_cost

SQL Concepts Used
-----------------
• INNER JOIN
• USING()
• MIN()
• MAX()
• Subquery
• UNION

===============================================================================
SQL Solution
===============================================================================
*/

SELECT
      dp.product_code,
      product,
      fmc.manufacturing_cost,
      fmc.cost_year
FROM dim_product AS dp
JOIN fact_manufacturing_cost AS fmc
USING(product_code)

WHERE manufacturing_cost IN
(
      (SELECT MIN(manufacturing_cost)
       FROM fact_manufacturing_cost)

      UNION

      (SELECT MAX(manufacturing_cost)
       FROM fact_manufacturing_cost)
);


/*
===============================================================================
Explanation
===============================================================================

1. The dim_product table is joined with the fact_manufacturing_cost
   table using the common column product_code.

2. A subquery is used to retrieve the minimum manufacturing cost.

3. Another subquery retrieves the maximum manufacturing cost.

4. UNION combines both values into a single result set.

5. The WHERE IN clause filters the records so that only the products
   having either the minimum or maximum manufacturing cost are returned.

===============================================================================
Business Insight
===============================================================================

This analysis identifies products with the lowest and highest
manufacturing costs. Understanding manufacturing cost variations helps
the business evaluate production efficiency, pricing strategies,
supplier negotiations, and overall product profitability.

===============================================================================
Business Value
===============================================================================

• Supports cost optimization initiatives.
• Helps identify premium and low-cost products.
• Assists management in making pricing and sourcing decisions.
• Enables comparison of production costs across the product portfolio.

===============================================================================
Interview Perspective
===============================================================================

Why did we use the IN operator?

The IN operator allows us to filter rows matching multiple values.
Here, it retrieves products having either the minimum or the maximum
manufacturing cost without writing multiple WHERE conditions.

Why was UNION used instead of OR?

The two subqueries return separate values (minimum and maximum cost).
UNION combines them into a single result set, which can then be used
inside the IN clause for filtering.

Why did we use USING(product_code)?

Since both tables contain a column named product_code, USING() provides
a cleaner syntax than ON dp.product_code = fmc.product_code while
achieving the same result.

===============================================================================
*/

/*
===============================================================================
Question 6 : Top 5 Customers with the Highest Average Pre-Invoice Discount
===============================================================================

Business Requirement
--------------------
Generate a report containing the Top 5 customers who received the
highest average pre-invoice discount percentage during Fiscal Year 2021
in the Indian market.

The final output should contain the following fields:

• Customer Code
• Customer
• Average Discount Percentage

Business Objective
------------------
Identify the customers receiving the highest average pre-invoice
discounts in the Indian market during FY2021. This helps the business
evaluate discount strategies, strengthen customer relationships,
and analyze pricing effectiveness.

Expected Output
---------------
• customer_code
• customer
• average_discount_percentage

SQL Concepts Used
-----------------
• INNER JOIN
• AVG()
• ROUND()
• GROUP BY
• ORDER BY
• LIMIT

===============================================================================
SQL Solution
===============================================================================
*/

SELECT
      dc.customer_code,
      customer,
      ROUND(AVG(pre_invoice_discount_pct),4) AS avg_discount_percentage

FROM dim_customer AS dc

JOIN fact_pre_invoice_deductions AS fpid
ON dc.customer_code = fpid.customer_code

WHERE dc.market = "India"
AND fpid.fiscal_year = 2021

GROUP BY (dc.customer_code)

ORDER BY avg_discount_percentage DESC

LIMIT 5;


/*
===============================================================================
Explanation
===============================================================================

1. The dim_customer table is joined with the
   fact_pre_invoice_deductions table using customer_code.

2. The WHERE clause filters only Indian customers
   for Fiscal Year 2021.

3. AVG() calculates the average pre-invoice discount
   percentage received by each customer.

4. ROUND() formats the average discount value
   up to four decimal places.

5. GROUP BY creates one record for every customer.

6. ORDER BY sorts customers from highest to lowest
   average discount percentage.

7. LIMIT 5 returns only the top five customers.

===============================================================================
Business Insight
===============================================================================

This report identifies customers who receive the highest
average pre-invoice discounts in the Indian market.

The findings help management evaluate discount strategies,
identify high-value customers, understand pricing policies,
and assess whether the discounts provided are aligned with
overall business objectives.

===============================================================================
Business Value
===============================================================================

• Supports customer relationship management.

• Helps evaluate pricing and discount strategies.

• Identifies customers receiving the highest incentives.

• Assists management in optimizing future discount policies.

===============================================================================
Interview Perspective
===============================================================================

Why did we use AVG()?

Because every customer may have multiple transactions,
AVG() calculates the overall average discount percentage
received by each customer instead of showing individual
transaction discounts.

Why did we use GROUP BY customer_code?

GROUP BY groups all transactions belonging to the same
customer, allowing aggregate functions like AVG()
to calculate customer-level metrics.

Why did we use LIMIT 5?

LIMIT returns only the Top 5 customers after sorting
them in descending order of average discount percentage.

===============================================================================
*/

/*
===============================================================================
Question 7 : Monthly Gross Sales Analysis for "Atliq Exclusive"
===============================================================================

Business Requirement
--------------------
Generate a complete report showing the Gross Sales Amount for customer
"Atliq Exclusive" for each month. This analysis helps identify
high-performing and low-performing months and supports strategic
business decisions.

The final output should contain the following fields:

• Month
• Year
• Gross Sales Amount

Business Objective
------------------
Analyze the monthly gross sales performance of Atliq Exclusive to
identify seasonal sales trends, peak-performing months, and business
growth opportunities.

Expected Output
---------------
• Month
• Year
• Gross Sales Amount

SQL Concepts Used
-----------------
• INNER JOIN
• SUM()
• GROUP BY
• MONTHNAME()
• YEAR()
• Aggregate Functions

===============================================================================
SQL Solution
===============================================================================
*/

SELECT
      fsm.date,
      MONTHNAME(fsm.date) AS month,
      YEAR(fsm.date) AS year,
      fsm.fiscal_year,
      dc.customer,

      #(SUM(fsm.sold_quantity)) AS monthly_sold_qty,
      #(SUM(fgp.gross_price)) AS monthly_gross,

      (SUM(fsm.sold_quantity * fgp.gross_price)) AS monthly_gross_sales_amt

FROM fact_sales_monthly AS fsm

JOIN dim_customer AS dc
ON fsm.customer_code = dc.customer_code

JOIN fact_gross_price AS fgp
ON fsm.product_code = fgp.product_code

WHERE dc.customer = "Atliq Exclusive"

GROUP BY month, year;


/*
===============================================================================
Explanation
===============================================================================

1. The fact_sales_monthly table is joined with the dim_customer table
   to retrieve customer details.

2. The fact_gross_price table is joined to obtain the gross price
   of each product.

3. The WHERE clause filters the data for only the customer
   "Atliq Exclusive."

4. Gross Sales Amount is calculated by multiplying
   Sold Quantity × Gross Price.

5. MONTHNAME() extracts the month name from the date.

6. YEAR() extracts the calendar year.

7. GROUP BY aggregates the sales data month-wise and year-wise.

===============================================================================
Business Insight
===============================================================================

This report provides a month-wise analysis of gross sales generated
by Atliq Exclusive. It enables stakeholders to identify seasonal
sales patterns, compare monthly business performance, and recognize
months that contribute the highest and lowest revenue.

===============================================================================
Business Value
===============================================================================

• Helps identify peak sales months.

• Supports monthly sales performance analysis.

• Assists management in forecasting future demand.

• Enables better inventory and production planning.

• Supports strategic business decision-making.

===============================================================================
Interview Perspective
===============================================================================

Why did we multiply Sold Quantity by Gross Price?

The Gross Sales Amount represents the total revenue generated before
any deductions or discounts. It is calculated using the formula:

Gross Sales = Sold Quantity × Gross Price

Why did we use MONTHNAME() and YEAR()?

MONTHNAME() improves readability by displaying month names instead
of numbers, while YEAR() separates sales across different calendar
years.

Why did we use GROUP BY month, year?

Since multiple transactions can occur within the same month,
GROUP BY aggregates all transactions into a single monthly record.

===============================================================================
*/

/*
===============================================================================
Question 8 : Quarter with the Highest Total Sold Quantity (FY2020)
===============================================================================

Business Requirement
--------------------
Determine which quarter of Fiscal Year 2020 recorded the highest
total sold quantity.

The final output should contain the following fields:

• Quarter
• Total Sold Quantity

Business Objective
------------------
Analyze quarterly sales performance during Fiscal Year 2020 to
identify the strongest sales quarter. This helps stakeholders
understand seasonal demand patterns and supports production,
inventory, and sales planning.

Expected Output
---------------
• Quarter
• Total Sold Quantity

SQL Concepts Used
-----------------
• CASE Statement
• SUM()
• GROUP BY
• ORDER BY
• Aggregate Functions
• Derived Table (Subquery)

===============================================================================
SQL Solution
===============================================================================
*/

SELECT

      CASE
          WHEN month IN (9,10,11) THEN 'Q1'
          WHEN month IN (12,1,2) THEN 'Q2'
          WHEN month IN (3,4,5) THEN 'Q3'
          WHEN month IN (6,7,8) THEN 'Q4'
          ELSE 'Q'
      END AS Quarter_month,

      SUM(sold_quantity) AS Quarter_wise_sold_qty

FROM
(
      SELECT
             date,
             MONTH(date) AS month,
             sold_quantity,
             fiscal_year
      FROM fact_sales_monthly

) AS quater_table

WHERE fiscal_year = 2020

GROUP BY Quarter_month

ORDER BY Quarter_wise_sold_qty DESC;


/*
===============================================================================
Explanation
===============================================================================

1. A derived table is created to extract the month number from the
   transaction date using the MONTH() function.

2. The CASE statement maps each month to its corresponding
   fiscal quarter.

3. The WHERE clause filters the dataset for Fiscal Year 2020.

4. SUM() calculates the total sold quantity for each quarter.

5. GROUP BY combines all transactions belonging to the same
   fiscal quarter.

6. ORDER BY sorts the quarters in descending order based on
   total sold quantity so that the highest-performing quarter
   appears first.

===============================================================================
Business Insight
===============================================================================

This analysis highlights the quarter that generated the highest
sales volume during Fiscal Year 2020. Understanding quarterly
sales performance helps identify seasonal demand trends and
supports better forecasting, production planning, and inventory
management.

===============================================================================
Business Value
===============================================================================

• Identifies the strongest-performing quarter.

• Supports demand forecasting and production planning.

• Helps optimize inventory allocation.

• Enables data-driven seasonal business strategies.

===============================================================================
Interview Perspective
===============================================================================

Why did we use a CASE statement?

The CASE statement categorizes each month into its corresponding
fiscal quarter. Since the company's fiscal year starts in
September, the quarter mapping differs from the standard
calendar year.

Why was a derived table used?

The derived table extracts the month number only once, making
the main query easier to read and allowing the CASE statement
to work with the generated month column.

Why did we use SUM()?

SUM() aggregates the sold quantities of all transactions within
each quarter, providing the total sales volume for comparison.

===============================================================================
*/

/*
===============================================================================
Question 9 : Channel-wise Gross Sales Contribution (FY2021)
===============================================================================

Business Requirement
--------------------
Identify which sales channel contributed the highest Gross Sales during
Fiscal Year 2021 and calculate the percentage contribution of each
channel.

The final output should contain the following fields:

• Channel
• Gross Sales (Million)
• Percentage Contribution

Business Objective
------------------
Analyze the contribution of each sales channel towards the company's
overall Gross Sales in FY2021. This helps stakeholders understand which
sales channels generate the highest revenue and supports strategic
business decisions regarding sales and marketing investments.

Expected Output
---------------
• Channel
• Gross_Sales_Mln
• Gross_Sales_Pct

SQL Concepts Used
-----------------
• Common Table Expression (CTE)
• INNER JOIN
• SUM()
• Window Function
• CONCAT()
• ROUND()
• GROUP BY

===============================================================================
SQL Solution
===============================================================================
*/

WITH CTE9 AS
(
      SELECT

             dc.channel,

             CONCAT(
                    ROUND(
                           SUM(fgp.gross_price * fsm.sold_quantity) / 1000000,
                           2
                    ),
                    " M"
             ) AS Gross_Sales_mlns

      FROM fact_sales_monthly AS fsm

      JOIN dim_customer AS dc
      ON fsm.customer_code = dc.customer_code

      JOIN fact_gross_price AS fgp
      ON fsm.product_code = fgp.product_code

      WHERE fsm.fiscal_year = 2021

      GROUP BY channel
)

SELECT
       *,

       CONCAT(
              ROUND(
                     gross_sales_mlns * 100 /
                     SUM(gross_sales_mlns) OVER(),
                     2
              ),
              " %"
       ) AS Gross_Sales_pct

FROM CTE9

ORDER BY Gross_Sales_pct DESC;


/*
===============================================================================
Explanation
===============================================================================

1. The CTE (CTE9) calculates the Gross Sales generated by each sales
   channel during Fiscal Year 2021.

2. Gross Sales is calculated by multiplying Sold Quantity with
   Gross Price.

3. The result is converted into Millions and formatted using CONCAT().

4. The Window Function SUM() OVER() calculates the total Gross Sales
   across all channels.

5. Each channel's contribution percentage is calculated by dividing
   its Gross Sales by the total Gross Sales.

6. The final output is sorted in descending order of contribution,
   showing the highest revenue-generating channel first.

===============================================================================
Business Insight
===============================================================================

This analysis highlights the contribution of each sales channel
towards the company's Gross Sales in FY2021.

It enables stakeholders to identify the highest-performing channels,
understand revenue distribution, and make informed decisions regarding
sales strategy, channel expansion, and marketing investments.

===============================================================================
Business Value
===============================================================================

• Measures channel-wise business performance.

• Identifies the highest revenue-generating sales channel.

• Supports channel optimization strategies.

• Assists management in allocating sales and marketing resources
  more effectively.

===============================================================================
Interview Perspective
===============================================================================

Why did we use a Window Function?

The Window Function SUM() OVER() calculates the total Gross Sales
without collapsing the result into a single row. This allows each
channel's percentage contribution to be calculated while retaining
individual channel records.

Why did we use a CTE?

The CTE simplifies the query by first calculating Gross Sales for
each channel and then using those results to compute percentage
contributions.

Why did we use CONCAT()?

CONCAT() formats the output by appending "M" for Millions and "%"
for percentage values, making the report easier for business users
to interpret.

===============================================================================
*/

/*
===============================================================================
Question 10 : Top 3 Products in Each Division by Total Sold Quantity (FY2021)
===============================================================================

Business Requirement
--------------------
Retrieve the Top 3 products in each division based on the highest
total sold quantity during Fiscal Year 2021.

The final output should contain the following fields:

• Division
• Product Code
• Total Sold Quantity
• Rank

Business Objective
------------------
Identify the best-performing products within each division by
analyzing total sales quantity. This enables stakeholders to
recognize top-selling products, evaluate product performance,
and support strategic inventory and sales planning.

Expected Output
---------------
• Division
• Product Code
• Total Sold Quantity
• Rank

SQL Concepts Used
-----------------
• Common Table Expressions (CTEs)
• INNER JOIN
• SUM()
• GROUP BY
• DENSE_RANK()
• Window Functions

===============================================================================
SQL Solution
===============================================================================
*/

WITH CTE10 AS
(
      SELECT

             fsm.product_code,

             division,

             SUM(sold_quantity) AS Total_Sold_Qty

      FROM dim_product AS dp

      JOIN fact_sales_monthly AS fsm
      ON dp.product_code = fsm.product_code

      WHERE fsm.fiscal_year = 2021

      GROUP BY product_code

      ORDER BY division,
               Total_Sold_Qty DESC
),

CTE10_1 AS
(
      SELECT

             CTE10.product_code,

             DENSE_RANK() OVER
             (
                    PARTITION BY division
                    ORDER BY Total_Sold_Qty DESC
             ) AS ranking

      FROM CTE10
)

SELECT

       CTE10.product_code,

       CTE10.division,

       CTE10.Total_Sold_Qty,

       CTE10_1.ranking

FROM CTE10

JOIN CTE10_1

ON CTE10.product_code = CTE10_1.product_code

WHERE ranking <= 3;


/*
===============================================================================
Explanation
===============================================================================

1. The first CTE (CTE10) joins the Product and Sales tables and
   calculates the total sold quantity for each product during
   Fiscal Year 2021.

2. Products are grouped by Product Code, and the total quantity
   sold is calculated using the SUM() function.

3. The second CTE (CTE10_1) applies the DENSE_RANK() window
   function to rank products within each division based on
   Total Sold Quantity.

4. PARTITION BY ensures that ranking restarts for every division.

5. The final query joins both CTEs and filters the results to
   display only the Top 3 ranked products from each division.

===============================================================================
Business Insight
===============================================================================

This analysis identifies the highest-selling products within each
business division. It enables management to recognize top-performing
products, understand customer demand, and prioritize products that
contribute significantly to overall sales performance.

===============================================================================
Business Value
===============================================================================

• Identifies best-selling products in every division.

• Supports inventory planning and demand forecasting.

• Helps marketing teams focus on high-performing products.

• Enables data-driven product portfolio optimization.

===============================================================================
Interview Perspective
===============================================================================

Why did we use DENSE_RANK() instead of RANK()?

DENSE_RANK() assigns consecutive rankings without leaving gaps.
If two products have the same sales quantity, both receive the
same rank, and the next rank continues sequentially. This is
useful when retrieving the Top N products from each division.

Why did we use PARTITION BY division?

PARTITION BY divides the dataset into separate groups based on
Division. Ranking is then calculated independently within each
division instead of across the entire dataset.

Why did we use two CTEs?

The first CTE calculates the total sold quantity for each product,
while the second CTE performs the ranking. Separating these steps
improves readability and makes the query easier to understand.

===============================================================================
End of Project
===============================================================================

Thank you for reviewing this SQL project.

This project demonstrates the application of SQL to solve
real-world business problems by transforming raw transactional
data into meaningful business insights.

Author : Anshul Saini

===============================================================================
*/


