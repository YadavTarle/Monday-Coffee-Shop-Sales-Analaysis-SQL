
-- monday cofee Data Analysis --

-- Show tables
SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- Reports & Data Analysis

-- Q.1 Coffee Consumer Count
-- How many people in each city are estimated to consume ,given that 25% of the populatipn does ?
SELECT city_name,
	   round((population*0.25)/1000000,2) as coffee_consumers_in_millions,
       city_rank
FROM city
ORDER BY population DESC,city_rank ASC;


-- 2.Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT SUM(total) as total_revenue
FROM sales
WHERE year(sale_date) = 2023 AND quarter(sale_date) = 4;

-- total sales by city
SELECT ct.city_name,
	   SUM(s.total) as total_revenue_byCity
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
WHERE year(s.sale_date) = 2023 AND quarter(s.sale_date) = 4
GROUP BY ct.city_name
ORDER BY 2 DESC;


-- 3. Sales Count for each product
-- How many units of each coffee product have been sold ?

SELECT p.product_id,p.product_name,
	   COUNT(s.sale_id) as total_orders
FROM products as p
LEFT JOIN
sales as s
ON s.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_orders DESC;


-- 4. Average Sales Amount per City
-- What is the average sales amount per customer in each city ?

SELECT ct.city_name as city_name ,
		SUM(s.total) as total_revenue,
        COUNT(DISTINCT c.customer_id) as total_cutomer,
        ROUND(SUM(s.total) / COUNT(DISTINCT c.customer_id) ,2) as avg_sale_customer_city
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON c.city_id = ct.city_id
GROUP BY city_name
ORDER BY total_revenue DESC;


-- 5. City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- retrun city_name ,total, current cx, estimated consumers (25%)
WITH city_table as (
		SELECT city_name,
			   population,
			   ROUND((population*0.25/1000000),2) as coffee_consumer_in_millions
		FROM city 
        ),
customer_table AS
(
SELECT ct.city_name,
		COUNT(DISTINCT c.customer_id) as unique_cx
FROM sales s
JOIN customers as c
ON c.customer_id = s.customer_id
JOIN city as ct
ON ct.city_id = c.city_id
GROUP BY 1
)
SELECT 
	customer_table.city_name,
    city_table.coffee_consumer_in_millions,
    customer_table.unique_cx
FROM city_table 
JOIN 
customer_table 
ON city_table.city_name = customer_table.city_name;


-- 6. Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume ?
SELECT * 
FROM 
(SELECT ct.city_name,
	   p.product_name,
	   COUNT(s.sale_id) as total_orders,
       DENSE_RANK() OVER ( PARTITION BY ct.city_name ORDER BY COUNT(s.sale_id) DESC) as rank_
FROM sales as s
JOIN products as p
ON s.product_id = p.product_id
JOIN customers as c
ON c.customer_id = s.customer_id
JOIN city as ct
ON ct.city_id = c.city_id
GROUP BY 1,2 ) as t1
WHERE rank_ <= 3;


-- 7. Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

SELECT 
	ct.city_name,
    COUNT(DISTINCT c.customer_id) as unique_customer
FROM city ct
LEFT JOIN customers c
ON ct.city_id = c.city_id
JOIN sales s
ON s.customer_id = c.customer_id
WHERE s.product_id IN  (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
GROUP BY 1;


-- 8. Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

WITH city_sale as 
( 
	SELECT 
		ci.city_name,
        SUM(s.total) as total_revenue,
        COUNT(DISTINCT s.customer_id) as total_cx,
        ROUND(
			SUM(s.total) / COUNT(DISTINCT s.customer_id),2)
            as avg_sale_pr_cx
	FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
    JOIN city ci 
    ON ci.city_id = c.city_id
    GROUP BY 1
    ORDER BY 2 DESC
),
city_rent
AS 
(SELECT 
	city_name,
    estimated_rent
FROM city
)
SELECT cr.city_name,
	   cr.estimated_rent,
       cs.total_cx,
       cs.avg_sale_pr_cx,
       ROUND(cr.estimated_rent/ cs.total_cx ,2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_sale as cs
ON cr.city_name = cs.city_name;
    

-- 9. Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

-- 10. Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer







