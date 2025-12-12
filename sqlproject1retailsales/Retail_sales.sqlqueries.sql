create database retail_sales;


drop table if exists retail;


create table retail(
transactions_id	int primary key,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(50),
age	int ,
category varchar(50),
quantiy	int, 
price_per_unit	float,
cogs	float,
total_sale	float
);


select * from retail
limit 10;

select count(*) from retail;

--
select * from retail
where transactions_id is null;

--
select  * from retail
where sale_date is null;

--
select  * from retail
where sale_time is null;

select * from retail
where customer_id is null;
--
select * from retail
where  gender is null;

--
select * from retail
where age is null;

--
select * from retail
where category is null or
	quantiy is null or
	price_per_unit is null or
	cogs is null or
total_sale is null;


-- Delete null records

delete from retail
where category is null or
	quantiy is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null;

--
select count(*) from retail;

--Data exploration

select count(total_sale) from retail as no_of_sales;

-- How many unique customers we have?

select count(distinct(customer_id)) from retail as unique_customers;

select distinct category from retail as category;

--Data analysis & Key problems
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail
where category = 'Clothing' and 
			to_char(sale_date,'yyyy-mm') = '2022-11'
			and
			quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as totalsales
from retail
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
round(avg(age),2) as avergae_age 
from retail
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(transactions_id),gender,category from retail
group by category,gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from 
	(select
	extract(YEAR FROM sale_date) as year,
	extract(MONTH FROM sale_date) as month,
	avg(total_sale) as avg_sale,
rank() over(partition by extract(YEAR FROM sale_date) order by avg(total_sale) desc) as rank
from retail
group by 1, 2) t
where t.rank = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as highest_total_sales
from retail
group by customer_id
order by highest_total_sales desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct(customer_id)),category
from retail
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(select * ,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail)
select shift, count(transactions_id)
from hourly_sale
group by  shift;

--- END OF PROJECT --
		
