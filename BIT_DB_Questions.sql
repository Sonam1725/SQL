--# Answering Questions about sales data. 

SELECT * FROM JanSales js Limit 10;

-- #1 How many orders were placed in January?
SELECT COUNT(orderID) AS total_orders
FROM JanSales js;

-- #2 How many of those orders were for an iPhone?
SELECT COUNT(orderID) AS total_orders
FROM JanSales js 
WHERE Product = "iPhone";

-- #3 Select the customer account numbers for all the orders that were placed in February.
SELECT c.acctnum
FROM customers c 
INNER JOIN FebSales fs 
ON c.order_id = fs.orderID;

-- #4 Which product was the cheapest one sold in January, and what was the price? 
SELECT DISTINCT Product, MIN(price) AS min_price
FROM JanSales js
GROUP BY Product, price
ORDER BY min_price ASC 
LIMIT 1;

-- #5 What is the total revenue for each product sold in January? (Revenue can be calculated using the number of products sold and the price of the products).
SELECT Product, Round(sum(Quantity) * price,2) as revenue
FROM JanSales js
Group by Product
ORDER by revenue desc;

-- #6 Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?
SELECT Product, SUM(Quantity), Round(sum(Quantity) * price,2) as revenue
FROM FebSales fs 
WHERE location ='548 Lincoln St, Seattle, WA 98101'
GROUP BY Product;


-- #7 How many customers ordered more than 2 products at a time in February, and what was the average amount spent for those customers?
SELECT COUNT(c.acctnum) as Customer_2_order, avg(fs.Quantity) * fs.price as avg_revenue
FROM FebSales fs 
left join customers c 
on c.order_id = fs.orderID
where fs.Quantity > 2;


