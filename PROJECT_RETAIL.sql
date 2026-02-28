use sql_project;
select * from retail_sales limit 500;
select count(*) from retail_sales;
select * from retail_sales where transactions_id is Null;

-- DATA CLEANING
-- check for null values and delete it if majority entities are not available

DELETE from retail_sales 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- DATA EXPLORATION

-- Q1. HOW MANY UNIQUE CUSTOMERS DO WE HAVE

SELECT COUNT(distinct(customer_id)) AS TOTAL_SALES FROM retail_sales;

-- Q1. HOW MANY UNIQUE CATEGORY DO WE HAVE

SELECT COUNT(distinct(category)) AS TOTAL_SALES FROM retail_sales;

-- DATA ANALYSIS | BUSINESS PROBLEMS AND ANSWERS

-- Q1 sales made on 2022-11-05

select * from retail_sales where sale_date = '2022-11-05'; 

--  -- q2 transactoin where category is clothing and quanity sold is more than 10

select *
from retail_sales 
where 
category = 'clothing'
And
quantiy >= 4;

-- Q3 TOTAL SALES FOR EACH CATEGORY

SELECT category, sum(total_sale) as net_sales, count(*) as total_orders FROM retail_sales group by category;

-- Q4 find average age of customers who purchased beauty items

select round(avg(age)) from retail_sales where category = 'Beauty';

-- Q5 transactions with sale > 1000

select transactions_id, total_sale from retail_sales where total_sale >= 1000;

-- Q6 total number of transactions made by each gender in each category

select count(transactions_id) as No_of_transaction, category, gender from retail_sales group by category, gender order by category;

-- Q7 Average  sale for each month and best sale month in each year

select year, month, avg_sale from
(
select 
round(avg(total_sale)) as avg_sale, 
extract(year from sale_date) as Year, 
extract(month from sale_date) as Month,
Rank() over(partition by extract(year from sale_date) order by avg(total_sale) DESC) as Ranking
from retail_sales 
group by 2, 3
)
as T1
where Ranking = 1;


-- Q8 top 5 customers  based on highest sale

 select customer_id, sum(total_sale) as total_sales from retail_sales group by 1 order by 2 Desc limit 5;

-- Q9 Unique customers from each category

select count(distinct customer_id) as unique_customer, category from retail_sales group by 2 order by category;

-- Q10 creat each shift and no. of orders i.e morning, afternoon and evening


-- transactions_id, Shift
with Hourly_sale 
as
(
select *,
case 
when extract(hour from sale_time) <12 then "Morning"
when extract(hour from sale_time) between 12 and 17 then "Afternoon"
Else "Evening"
end as Shift
from retail_sales
)
select
	shift,
    count(transactions_id) as total_orders
    from Hourly_sale
    Group by shift;
    
    -- END
