
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





