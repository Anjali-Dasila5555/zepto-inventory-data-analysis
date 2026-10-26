drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

select * from zepto;

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number_of_SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
select * from zepto;
SELECT mrp, discountedSellingPrice FROM zepto;

update zepto set mrp = mrp/100, discountedsellingprice = discountedsellingprice/100;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

select * from zepto order by zepto.discountpercent desc limit 10;

--Q2.What are the Products with High MRP but Out of Stock
select distinct(name) , category, mrp from zepto where zepto.outofstock = TRUE order by mrp desc ;


--Q3.Calculate Estimated Revenue for each category
select * from zepto;

select category,sum(mrp*availablequantity) as each_category
from zepto 
group by category
order by sum(mrp*availablequantity);

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

select * from zepto where mrp > 500 and discountpercent < 10;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discountpercent),2) as dis_a from zepto
group by category 
order by avg(discountpercent) desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select * from zepto;

select name,weightingms,round((weightingms/discountedsellingprice),2) as price_of_perWeight
from zepto where weightingms >1

--Q7.Group the products into categories like Low, Medium, Bulk.

select *,
case
when zepto.weightingms <= 100 then 'Low'
when zepto.weightingms <= 200 then 'Medium'
else 'Bulk'
end as categoies
from zepto;

  
--Q8.What is the Total Inventory Weight Per Category 

select category, sum(availablequantity * mrp) as total_cost from zepto
group by category
order by total_cost desc;

