LOAD DATA LOCAL INFILE 'C:/Users/Abinaya RS/E-Commerce Sales & Customer Analytics/ecommerce_sales_cleaned.csv'
INTO TABLE ecommerce_analytics.ecommerce_sales_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE 'C:/Users/Abinaya RS/E-Commerce Sales & Customer Analytics/ecommerce_sales_cleaned.csv'
INTO TABLE ecommerce_analytics.ecommerce_sales_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@secure_file_priv;
SELECT CONCAT(@@secure_file_priv, 'ecommerce_sales_cleaned.csv');
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_sales_cleaned.csv'
INTO TABLE ecommerce_analytics.ecommerce_sales_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM ecommerce_analytics.ecommerce_sales_cleaned;
SELECT
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned;
SELECT
    Month,
    ROUND(SUM(Revenue), 2) AS monthly_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Month
ORDER BY Month;
SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE TRIM(CustomerID) <> ''
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE TRIM(CustomerID) <> ''
GROUP BY CustomerID
ORDER BY total_orders DESC
LIMIT 10;

SELECT
    ROUND(SUM(Revenue) / COUNT(DISTINCT InvoiceNo), 2) AS average_order_value
FROM ecommerce_analytics.ecommerce_sales_cleaned

SELECT
    CASE
        WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE TRIM(CustomerID) <> ''
GROUP BY CustomerID;

SELECT
    customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        CustomerID,
        CASE
            WHEN COUNT(DISTINCT InvoiceNo) = 1
                THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE TRIM(CustomerID) <> ''
    GROUP BY CustomerID
) AS customer_segments
GROUP BY customer_type;

SELECT
    customer_type,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM (
    SELECT
        CustomerID,
        SUM(Revenue) AS total_revenue,
        CASE
            WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE TRIM(CustomerID) <> ''
    GROUP BY CustomerID
) AS customer_segments
GROUP BY customer_type;

SELECT
    customer_type,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM (
    SELECT
        CustomerID,
        CASE
            WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE TRIM(CustomerID) <> ''
    GROUP BY CustomerID
) AS customer_segments
GROUP BY customer_type;

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    Description,
    SUM(Quantity) AS total_quantity
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;

SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    Description,
    SUM(Quantity) AS total_quantity
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;

-- 8. Monthly Revenue Trend

SELECT
    Month,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Month
ORDER BY Month;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    Month,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Month
ORDER BY Month;

SELECT
    Month,
    ROUND(SUM(Revenue) / COUNT(DISTINCT InvoiceNo), 2) AS monthly_aov
FROM ecommerce_analytics.ecommerce_sales_cleaned
GROUP BY Month
ORDER BY Month;

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS customer_orders;

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS customer_orders
GROUP BY customer_type;

SELECT
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM ecommerce_analytics.ecommerce_sales_cleaned
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS customer_orders;

SELECT
    CustomerID,
    ROUND(SUM(Revenue) / COUNT(DISTINCT InvoiceNo), 2) AS customer_aov
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY customer_aov DESC
LIMIT 10;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(Revenue) DESC
    ) AS revenue_rank
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY revenue_rank
LIMIT 10;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(Revenue) DESC
    ) AS revenue_rank
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY revenue_rank
LIMIT 10;

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(Revenue) DESC
    ) AS revenue_rank
FROM ecommerce_analytics.ecommerce_sales_cleaned
WHERE CustomerID IS NOT NULL
  AND TRIM(CustomerID) <> ''
GROUP BY CustomerID
ORDER BY revenue_rank
LIMIT 10;