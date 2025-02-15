CREATE TABLE RETAIL_SALES
           (
           transactions_id INT PRIMARY KEY,
           sale_date DATE,
		   sale_time TIME,
		   customer_id INT,
		   gender VARCHAR(50),
		   age INT,
		   category VARCHAR(50),
		   quantity INT,
		   price_per_unit FLOAT,
		   cogs FLOAT,
		   total_sale FLOAT
           );

SELECT * FROM RETAIL_SALES
LIMIT 10

--
SELECT COUNT (*) FROM RETAIL_SALES
--DATA CLEANING
SELECT * FROM RETAIL_SALES
WHERE 
         transactions_id is NULL
         OR
		 sale_date IS NULL
		 OR 
		 sale_time IS NULL
		 OR 
		 customer_id IS NULL
		 OR 
		 gender IS NULL
		 OR 
		 age IS NULL
		 OR 
		 category IS NULL
		 OR  
		 quantity IS NULL
		 OR  
		 price_per_unit IS NULL
		 OR  
		 cogs IS NULL
		 OR  
		 total_sale IS NULL
--
DELETE FROM RETAIL_SALES
WHERE
      transactions_id is NULL
         OR
		 sale_date IS NULL
		 OR 
		 sale_time IS NULL
		 OR 
		 customer_id IS NULL
		 OR 
		 gender IS NULL
		 OR 
		 age IS NULL
		 OR 
		 category IS NULL
		 OR  
		 quantity IS NULL
		 OR  
		 price_per_unit IS NULL
		 OR  
		 cogs IS NULL
		 OR  
		 total_sale IS NULL
--DATA EXPLORATION
--How many sales do we have?
SELECT COUNT (*) AS total_sale FROM RETAIL_SALES

--How many cutomers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM RETAIL_SALES

--How many categories do we have?
SELECT DISTINCT category FROM RETAIL_SALES

--Data Analysis, Business Key problems and answers--
--1. Write an SQL Query to retrieve all columns for sales made on 2022-11-05?

SELECT * FROM RETAIL_SALES
WHERE sale_date = '2022-11-05'

--2. Write an SQL Query to retrieve all transactions where the category is 'clothing' and  quantity sold is more than 2 in the month of november 2022?
SELECT * FROM RETAIL_SALES
WHERE category = 'Clothing'
     AND 
	 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
     AND 
	 quantity >= 2

--3. Write an SQL query to calculate the total sales of each category.

SELECT category,
     SUM (total_sale) as net_sales,
	 COUNT (*) as total_order
	 FROM RETAIL_SALES
	 GROUP BY 1
	 
--4.Write an SQL query to find the average age of customers who purchased items from beauty category.
    SELECT AVG(age) FROM RETAIL_SALES
	WHERE 
	     category = 'Beauty'

--5.Write an SQL query to find all transaction where the total_sale is greater than 1000.
 SELECT * FROM RETAIL_SALES
 WHERE total_sale >= 1000

 --6.Write an SQL query to find the total number of transactions(transaction_id) made by each gender in each category.
 SELECT 
       category,
	   gender,
	   COUNT(*) AS total_trans
	   FROM RETAIL_SALES
	   GROUP BY 
	          category,
			  gender
	   ORDER BY 1
 --7.Write an SQL query to calculate the average sales for every month. Find out best sellig month in each year.
  SELECT 
  EXTRACT (YEAR from sale_date) AS year,
  EXTRACT (MONTH from sale_date) AS month,
  AVG( total_sale) as avg_sale
  FROM RETAIL_SALES
  GROUP BY 1,2
  ORDER BY 1,2,3 DESC

  SELECT
        year,
		month,
		avg_sale

 FROM 
 (
  EXTRACT(YEAR from sale_date) AS year,
  EXTRACT (MONTH from sale_date) AS month,
  AVG( total_sale) as avg_sale,
  RANK() OVER (PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG (total_sale) DESC) AS rank
  FROM RETAIL_SALES
  GROUP BY 1,2
 ) AS t1
 WHERE rank = 1
 --incomplete

 --8.Write an SQL Query to find out the top 5 customers on the highest total sales.
 SELECT 
       customer_id,
	   SUM (total_sale) AS total_sales
 FROM RETAIL_SALES
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5

 --9 Write an SQL Query to find out the unique customers who purchased items from each category
 SELECT
	   category,
	   COUNT (DISTINCT customer_id) AS cnt_unique_cs
	   FROM RETAIL_SALES
	   GROUP BY category

 --10.Write an SQL Query to create each shift and number of orders (eg morning shift < 12, afternoon shift between 12 to 17 and evening shift i.e from  >17)
  
WITH hourly_sale
AS
( 
SELECT *,
     CASE 
		 WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
 END as shift
 FROM RETAIL_SALES
 )
 SELECT 
      shift,
	  COUNT (*) AS total_orders
 FROM hourly_sale
 GROUP BY shift
 
  
 