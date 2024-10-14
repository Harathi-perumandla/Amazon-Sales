/*Mysql Amazon Project*/
use amazon_project;
select * from amazon_project.amazon;

/*2-Feature Engineering: This will help us generate some new columns from existing ones.
/*2.1--Adding Add a new column named timeofday*/

alter table amazon_project.amazon
add column timeof_day varchar(50) after time;

/*Updating values in time of daty column*/
set sql_safe_updates = 0;

update amazon_project.amazon
set timeof_day =
case
     when time(time) >= '00:00:00' and time(time) < '12:00:00' then 'Morning'
     when time(time) >= '12:00:00' and time(time) < '18:00:00' then 'Afternoon'
     else 'Evening'
end;


/* 2.2--Adding new column dayname next to date column*/

alter table amazon_project.amazon
add column Day_name varchar(30) after date;

/* updating values in dayname column*/
update amazon_project.amazon
set Day_name =
 case dayofweek (Date)
       when 1 then 'Sun'
       when 2 then 'Mon'
       when 3 then 'tue'
       when 4 then 'wed'
       when 5 then 'thu'
       when 6 then 'fri'
       when 7 then 'sat'
	end;
    
/* 2.3--Adding column monthname*/
alter table amazon_project.amazon
add column Month_name varchar(30) after Day_name;

/*updating values in Month name column*/
update amazon_project.amazon
set Month_name =
 case Month (Date)
        when 1 then 'Jan'
        when 2 then 'Feb'
        when 3 then 'Mar'
        when 4 then 'Apr'
        when 5 then 'May'
        when 6 then 'Jun'
        when 7 then 'Jul'
        when 8 then 'Aug'
        when 9 then 'Sep'
        when 10 then 'Oct'
        when 11 then 'Nov'
        when 12 then 'Dec'
	end;
       
/*Business Questions*/
/*1)What is the count of distinct cities in the dataset?*/
select count(distinct city) as distinct_city from amazon_project.amazon;

/*2)For each branch, what is the corresponding city?*/
select city, branch from amazon_project.amazon;

/*3)What is the count of distinct product lines in the dataset?*/
SELECT count(distinct(`Product line`)) AS unique_product FROM amazon_project.amazon;

/*4)Which payment method occurs most frequently?*/
select payment, count(payment) as often from amazon_project.amazon
group by  payment
order by often desc;

/* 5)Which product line has the highest sales?*/
select `Product line`, count(*) as Total_sales 
from  amazon_project.amazon
group by `Product line`
order by Total_sales desc;

/* 6) How much revenue is generated each month?*/

select Month_name, sum(total) as revenue
from amazon_project.amazon
group by Month_name
order by revenue desc;

/* 7)In which month did the cost of goods sold reach its peak?*/

select Month_name, sum(cogs) as totcogs
from amazon_project.amazon
group by Month_name
order by totcogs desc;

/* 8)Which product line generated the highest revenue?*/

select `Product line`, sum(total) as heighest_revenue
from amazon_project.amazon
group by `product line`
order by heighest_revenue desc;

/* 9) In which city was the highest revenue recorded?*/
select City, sum(Total) as city_highest_revenue
from amazon_project.amazon
group by City
order by city_highest_revenue desc;

/* 10) Which product line incurred the highest Value Added Tax?*/
select `Product line`, sum(`Tax 5%`) as highest_tax
from amazon_project.amazon
group by `Product line` 
order by highest_tax desc;

/* 11)For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."*/

SELECT `Product line`,
       CASE WHEN Total > (SELECT AVG(Total) FROM amazon_project.amazon) THEN 'Good'
            ELSE 'Bad'
       END AS sales_performance
FROM amazon_project.amazon;

/*12)Identify the branch that exceeded the average number of products sold.*/

SELECT Branch, sum(Quantity) AS Total_Quantity
FROM amazon_project.amazon
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM amazon_project.amazon);

/*13) Which product line is most frequently associated with each gender?*/

SELECT `Product line`, Gender, count(*) AS Often_associate
FROM amazon_project.amazon
GROUP BY gender, `Product line`
ORDER BY Often_associate DESC;

/* 14) Calculate the average rating for each product line.*/

SELECT `Product line`, AVG(Rating) AS Avg_rating
FROM amazon_project.amazon
GROUP BY `Product line`
ORDER BY Avg_rating DESC;

/*15) Count the sales occurrences for each time of day on every weekday.*/

SELECT timeof_day, Day_name, count(*) AS Sales_Occurrence
FROM amazon_project.amazon
where Day_name IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri')
GROUP BY timeof_day, Day_name
ORDER BY Sales_Occurrence DESC;

/*16) Identify the customer type contributing the highest revenue.*/

SELECT `Customer type`, sum(Total) AS Highest_Revenue
FROM amazon_project.amazon
GROUP BY `Customer type`
ORDER BY Highest_Revenue DESC;

/* 17) Determine the city with the highest VAT percentage.*/

 SELECT city, sum(`Tax 5%`) AS highest_vat,sum(Total) AS Total_sales,
 (sum(`Tax 5%`) / sum(total)) * 100 AS Vatpersentage
 FROM amazon_project.amazon
 GROUP BY City
 ORDER BY Vatpersentage DESC;
 
 /*18) Identify the customer type with the highest VAT payments.*/
 
 SELECT `Customer type`, sum(`Tax 5%`) AS highest_payments
 FROM amazon_project.amazon
 GROUP BY `customer type`
 ORDER BY highest_payments DESC;
 
 /*19) What is the count of distinct customer types in the dataset?*/
 
 SELECT count(distinct(`Customer type`)) AS unique_customer_type
 FROM amazon_project.amazon;
 
 /*20)What is the count of distinct payment methods in the dataset?*/
 
 SELECT count(distinct(Payment)) AS unique_payment
 FROM amazon_project.amazon;
 
 /* 21)Which customer type occurs most frequently?*/
 
 SELECT `Customer type`, count(`Customer type`) AS frequent_customer_type
 FROM amazon_project.amazon
 GROUP BY `Customer type`
 ORDER BY frequent_customer_type DESC;
 
 /*22)Identify the customer type with the highest purchase frequency.*/
 
 SELECT `Customer type`, count(*) AS highest_purchase
 FROM amazon_project.amazon
 GROUP BY `Customer type`
 ORDER BY highest_purchase DESC;
 
 /* 23) Determine the predominant gender among customers.*/
 
 SELECT Gender, count(*) AS Predominent_gender
 FROM amazon_project.amazon
 GROUP BY Gender
 ORDER BY Predominent_gender DESC;
 
 /*24) Examine the distribution of genders within each branch.*/
 
 SELECT Branch, Gender, Count(*) AS Gender_count
 FROM amazon_project.amazon
 GROUP BY Gender, Branch
 ORDER BY Gender_count DESC;
 
 /*25) Identify the time of day when customers provide the most ratings.*/
 
SELECT timeof_day, count(Rating) AS count_rating
FROM amazon_project.amazon
GROUP BY timeof_day
ORDER BY count_rating DESC;

/*26) Determine the time of day with the highest customer ratings for each branch.*/

SELECT Branch, timeof_day, AVG(rating) AS avg_rating
FROM amazon_project.amazon
GROUP BY Branch, timeof_day
ORDER BY avg_rating DESC;

/*27)Identify the day of the week with the highest average ratings.*/

SELECT Day_name, AVG(Rating) AS highest_rating
FROM amazon_project.amazon
GROUP BY Day_name
ORDER BY  highest_rating DESC;

/* 28) Determine the day of the week with the highest average ratings for each branch.*/

SELECT Branch, Day_name, count(Rating) AS highest_week_avg_rating
FROM amazon_project.amazon
GROUP BY Branch, Day_name
ORDER BY highest_week_avg_rating DESC;





 

    