/* In this SQL queries, we will investigate which products are the best and worst selling products by each locations. This can help
us figure out which products, we should advertise more or less for each locations. We can also determine, which products generated the most 
sales and if they have any correlation with the quantity it sold. */

Use Product_Sales;

# Show only the distinct products?
SELECT DISTINCT
    (Product)
FROM
    product_sales;
    
# What cities were the products sold at?
SELECT DISTINCT
    (City)
FROM
    product_sales;

# What was the average price of all the products overall in all locations?
SELECT 
    ROUND(AVG(Sales), 2) as avg_price
FROM
    product_sales;

# Ans: The price of all the products overall was $185.49.

# Differentiate the products that cost more than the average price and the products that cost less?
Drop Temporary Table if exists Price_category;
Create Temporary table Price_category(Product Varchar (100), Price float, Cost Varchar(100)) 
as 
Select Product, Price,
Case when Price > 185 then "More than Average Price"
When Price < 185 then "Less than Average Price"
When Price = 185 then "Same"
Else Null
End as Cost
From product_sales
Order by Cost;

# How many products falls into each category (More than Average Price, Less than Average Pricee and is Same as Average Price)?
SELECT 
    SUM(CASE
        WHEN Cost = 'More than Average Price' THEN 1
        ELSE 0
    END) AS More_than_avg,
    SUM(CASE
        WHEN Cost = 'Less than Average Price' THEN 1
        ELSE 0
    END) AS less_than_avg,
    SUM(CASE
        WHEN Cost = 'Same' THEN 1
        ELSE 0
    END) AS same_as_avg
FROM
    Price_category;

# There were much more products that cost less than the overall average price than there were products that cost more than overall average price.
# More than average = 41,807, Less than average = 144,143.

# What was the average price of all products overall by city and the total quantity ordered?
SELECT 
    City, ROUND(AVG(Sales),0) AS avg_price, sum(Quantity_Ordered) as total_quantity
FROM
    product_sales
GROUP BY city
ORDER BY total_quantity DESC;

/* The most expensive average price overall was in the city of San Francisco with the average of $185, 
while the least was at Austin with a average price of 184.*/

# How much did each city generate in total sales?
Select city, Round(Sum(Sales),0) as Total_sales
From product_sales
Group by city
Order by Total_sales desc;

/* The city that generated the most sales was San Francisco with total sales of $8,262,204, while the least was in city of
Austin with sales of $1,819,582. Not only was San Francisco average price per product a dollar higher than Austin but they also had
39,086 more products sold than Austin. */ 

# What is the best and worst month for products sold and how much sales did each month generate?
SELECT 
    Month,
    SUM(Quantity_Ordered) AS total_quantity,
    ROUND(SUM(Sales), 0) AS total_sales
FROM
    product_sales
GROUP BY Month
ORDER BY total_quantity DESC; 

# Ans: The best month in terms of both total products sold and the sales generated was December, while the worst month was on January. 

# Which products were the most and least sold overall?
SELECT 
    product,
    SUM(Quantity_Ordered) AS total_order,
    ROUND(SUM(Sales),0) AS total_sales
FROM
    product_sales
GROUP BY product
ORDER BY total_order DESC;

/* The most ordered product was AAA Batteries (4-pack) with total of 31,017, while the least sold was LG Dryer
with only 646 orders sold. Although, AAA Batteries was sold much more than LG Dryer, the LG Dryer generated much more sales than AAA Batteries.
LG Dryer sales = $387,600 and AAA Batteries sales = $92,741 */

# Create a procedure to output how much each product sold in each of the City?
Drop procedure if exists Order_product_city;
Delimiter $$
Create procedure Order_product_city(in p_city varchar(100))
Begin
	Select City, product ,Sum(Quantity_Ordered) as total_order, Round(Sum(Sales),2) as total_sales
	From product_sales
    where City = p_city
	Group by City, product
	Order by City,total_order desc;
End$$
Delimiter ;
call Product_Sales.Order_product_city(' San Francisco');
call Product_Sales.Order_product_city(' Austin');
/* Using this procedure, we can identify how much each product was sold and the sales it generated based on the city.
We can use this to help figure out which products we should focus on based on the city.*/

# How much products was sold during each hour of the day?
SELECT 
    Hour, SUM(Quantity_ordered) AS total_ordered
FROM
    product_sales
GROUP BY Hour
ORDER BY Hour;

/* We know that AAA Batteries(4-pack) are the most popular products and that LG Dryer are the least popular.
How many of AAA Batteries and LG Dryer did each city sell? */
SELECT 
    City, Product, SUM(Quantity_Ordered) AS total_order
FROM
    product_sales
WHERE
    Product = 'AAA Batteries (4-pack)'
        OR Product = 'LG Dryer'
GROUP BY City , Product
ORDER BY Product , total_order DESC;

/* Knowing that AAA Batteries and LG Dryer are the best and worst selling products, where do they rank overall in terms of price? */
With product_rank as 
(Select Product, Round(Avg(Price),2) as Price
From product_sales
Group by Product)
Select product, price,
dense_rank() over (order by price desc) as Price_rank
From product_rank;

/* The AAA Batteries (4-pack) was ranked last in price with a total price of $2.99, while the LG Dryer was one of the most
expensive product sold ranking 4th overall with a price of $600. Knowing the price of each product and the price difference,
we can make conclussion that AAA Batteries was the most sold item probally due to how cheap it was compared to expensive product
like LG Dryer. */ 



