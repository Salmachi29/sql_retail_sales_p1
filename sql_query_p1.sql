-- SQL Retail Sales Analysis - P1
Create DATABASE sql_project_p2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

Select * FROM retail_sales
Limit 10

SELECT 
    Count (*)
	FROM retail_sales
	
--Data cleaning

Select * FROM retail_sales
Where transactions_id IS NULL


Select * FROM retail_sales
Where sale_date IS NULL

Select * FROM retail_sales
WHERE
    transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	age is null
	or
	category is null
	OR 
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

--
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	age is null
	or
	category is null
	OR 
	quantity is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;
	
--Data exploration

-- How many sales we have?
select count(*) as total_sale FROM retail_sales

-- How many unique customers we have?
select count(customer_id) as total_sale FROM retail_sales

-- How many categories we have?
select DISTINCT category as total_ FROM retail_sales  -- give us all the category names

-- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
From retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select *
from retail_sales
where 
    category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'   -- TO_CHAR()= Convert a value (like a date or a number) into text (a character string) using a specific format that I choose
	AND
	quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.:

select 
     category,                  -- SUM(total_sale) adds up the values in the total_sale column for every row that belongs to the same category
	 sum(total_sale) as net_sale,  -- as: renames SUM(total_sale) to net_sale in the ouput
	 count (*) as total_orders    -- counts how many rows (orders) belong to each cateogry|bcz of GROUP BY, it counts separately for every unique category
from retail_sales
group by 1;  -- or group by category; | it means group the results by the 1st column listed in the SELECT statement

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
    age
from retail_sales
Where category = 'Beauty'

Select
     AVG(age) as avg_age
from retail_sales
Where category = 'Beauty'

-- TO round the age
Select
     Round(AVG(age),2) as avg_age
from retail_sales
Where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select 
     *
from retail_sales
where 
    total_sale > 1000
	
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select
     category,
	 gender,
	 count(*) as total_trans
from retail_sales
Group by 1,2
ORDER by 1;   -- sort the results by the 1st column (category) > input will be grouped alphabetically

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select 
     year,
	 month,
	 avg_sale,
FROM
(
	SELECT 
       EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
	 EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
	 AVG(TOTAL_SALE) AS AVG_SALE,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) AS RANK -- Partition By= ranks whitin each subgroup ( like per year or per categroy) by desending avg sale
FROM RETAIL_SALES
GROUP BY 1,2
) AS t1  -- the inner query is creating a table called t1
where rank = 1 -- the outer query filters the results of t1 to keep only rows where rank = 1

--order by 1, 3 DESC 

-- Q.8 **Write a SQL query to find the top 5 customers based on the highest total sales **:

select * from retail_sales

select
    customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5  -- only the top 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.:

select
	 category,
	 count(DISTINCT customer_id) as unique_customers
from retail_sales
group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
-- we need to save the below query in a CTE = Common Table Expression = temporary table or subquery with a name

WITH hourly_sale AS
(
select *,
     case
	    when Extract(hour from sale_time)< 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
	 end as shift
from retail_sales
)

Select
     shift,
	 count(*) as total_orders
from hourly_sale  -- selecting from the above cte we created
group by 1
order by 1   -- to order shift alphabetically
-- order 2 desc: if we want to order by the highest number of orders

-- End of project