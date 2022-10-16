/* Using MYSQL, I analyze the data from Plato's Pizza and put together a report to help find them opportunities to drive more sales and work more efficiently.
The data set was extracted from Maven Analytic website, which provides free dataset to the public. */

USE Pizza_maven;
-- Creating the database and importing the datas
Create Database Pizza_maven;
use Pizza_maven;
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(20) NOT NULL,
    ingredients VARCHAR(250) NOT NULL
);

-- I changed the data type of date and time to their correct data types.
Alter table orders
change column date date date;

Alter table orders
change time time Time;

-- Answering questions to get better insights


-- What days of the week and time was the busiest ever?
SELECT 
    DAYNAME(o.date), o.time, sum(d.quantity) AS total_orders
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
GROUP BY DAYNAME(o.date) , o.time
ORDER BY sum(d.quantity) DESC , DAYNAME(o.date) , o.time;

-- What day of the week is the busiest?
SELECT 
    DAYNAME(o.date) as day_name, sum(d.quantity) AS total_orders
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
GROUP BY DAYNAME(o.date)
ORDER BY sum(d.quantity) DESC , DAYNAME(o.date);

-- Answer: Friday is the busiest day.

-- what time of the day is the busiest?
SELECT 
	hour(o.time), sum(d.quantity) AS total_orders
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
GROUP BY hour(o.time)
ORDER BY sum(d.quantity) DESC , hour(o.time);

-- Answer: The busiest time of the day is 12pm, which makes sense because its during lunch time.

-- How many pizzas are we making during peak periods?
SELECT 
    DAYNAME(o.date), hour(o.time), sum(d.quantity) AS total_orders
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
GROUP BY DAYNAME(o.date) , hour(o.time)
ORDER BY sum(d.quantity) DESC , DAYNAME(o.date) , hour(o.time);

-- Answer: The most pizza that was ordered is on Wednesday at 12:25:12 with total orders of 28.


-- What are our best and worst selling pizzas?
SELECT 
    t.name, sum(d.quantity) AS total_orders
FROM
    pizza_types t
        LEFT JOIN
    pizzas p ON p.pizza_type_id = t.pizza_type_id
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
GROUP BY t.name
ORDER BY total_orders DESC;

-- Answer: Best Overall selling = The Classic Deluxe Pizza at 2453 orders, The Worst Overall Selling = The Brie Carre Pizza at 490 orders.

-- Best and worst selling pizza by type and size?
SELECT 
    t.name, p.size, sum(d.quantity) AS total_orders
FROM
    pizza_types t
        LEFT JOIN
    pizzas p ON p.pizza_type_id = t.pizza_type_id
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
GROUP BY t.name, p.size
ORDER BY total_orders DESC;

-- Answer: The best selling pizza by size is the small The Big Meat Pizza with total orders of 1914, while the worst selling pizza is Extra Large The Greek Pizza with total orders of 28;

-- What's our average order value?
SELECT 
    ROUND(AVG(price),2) as Avg_price
FROM
    pizzas p
WHERE
    pizza_id IN (SELECT 
            pizza_id
        FROM
            order_details
        WHERE
            order_id IN (SELECT 
                    order_id
                FROM
                    orders));

-- Answer: The average order value was 16.51.


-- Everything 
SELECT 
    *
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
        JOIN
    pizzas p ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types t ON t.pizza_type_id = p.pizza_type_id;

SELECT 
    DAYNAME(o.date),sum(o.date)/sum(d.quantity) AS total_orders
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
Group by (o.date);

-- Which day generated the most money?
SELECT 
    DAYNAME(o.date), ROUND(SUM(p.price), 2) AS total_sales
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY DAYNAME(o.date)
ORDER BY total_sales DESC;

-- 
Select *
From pizzas
where price = (select max(price) from pizzas);

-- What is the most expensive pizza in the menu?
Select pt.name, pt.category, p.pizza_id, p.price, p.size
From pizzas p
Join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
where price = (select max(price) from pizzas);

-- The XXL The Greek Pizza is the most expensive pizza on the menu with the price of $35.95.

-- How much money did each pizza generate based on their name.
select pt.name, round(SUM(p.price),2) as money_generated
From orders o
        JOIN
    order_details d ON o.order_id = d.order_id
        JOIN
    pizzas p ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY PT.NAME
order by money_generated desc;

/* The pizza that generated the most money was The Thai Chicken Pizza, which generated a total of $42,332.25.
The pizza that generated the least money was The Brie Carre Pizza, which generated a total of $11,352.*/

-- How much money did each pizza generate based on their name and size.
SELECT 
    pt.name, p.size,pt.category, ROUND(SUM(p.price), 2) AS money_generated
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
        JOIN
    pizzas p ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY PT.NAME , p.size,pt.category
ORDER BY money_generated DESC;

/* The Large The Thai Chicken Pizza made the most money when broken down into name and size generating a total of $28,323.75,
while XXL The Greek Pizza generated the least amount of money by generating only total of $1,006.6.*/

-- What the min, avg and max of each pizza size?
Select size, round(min(price),2) as min_price, ROUND(AVG(price), 2) AS avg_price, round(max(price),2) as max_price
From pizzas
Group by size;

-- How much did each size generate?
Select p.size, round(sum(price),2) as total_sales
From  orders o                                              	-- We join the other tables becasue if we didn't then we wouldn't get the total of sales of all the orders and except would only get the total price in the menu.
        JOIN
    order_details d ON o.order_id = d.order_id
        JOIN
    pizzas p ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
Group by p.size
Order by total_sales desc;

-- We can see that the Large pizza generated the most sales, while the XXL pizza generated the least amount.

-- How much pizza was sold based on each size?
SELECT 
    p.size, SUM(od.quantity) AS total_orders
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC;

/* We can see that most of the pizzas sold are Large pizzas and if the store were to create a new pizza, creating a large pizza would be best for buisness.
However, XXL pizzas are not sold very often and doesn't generate as much money, so if the store were to take it off the menu and focus more on Large and Medium pizzas,
it could help drive up more buisness. */


-- The name of pizza broken down into size and their prices along with the avg price of each pizza. 
Select pt.name, p.size, p.price, round(avg(p.price) over (partition by pt.name),2) as avg_price
From pizzas p 
join pizza_types pt 
on p.pizza_type_id = pt.pizza_type_id
order by avg_price desc, pt.name, p.price desc;

-- How many times was each pizza's category ordered?
Select pt.category, sum(od.quantity) as total_orders
FROM
		 orders o
			JOIN
		order_details od ON o.order_id = od.order_id
			JOIN
		pizzas p ON p.pizza_id = od.pizza_id
			JOIN
		pizza_types pt ON pt.pizza_type_id = p.pizza_type_id 
Group by pt.category
Order by total_orders desc;

-- Classic pizzas were ordered the most while, Chicken was ordered the least.

-- Create a stored procedure to provide the avg price of all the size when called upon.
drop procedure if exists Avg_price;
delimiter $$
Create procedure Avg_price()
Begin 
SELECT 
    size, Round(AVG(price),2) as avg_price
FROM
    pizzas
GROUP BY size;
End$$ 
DELIMITER ;
Call Avg_price();

-- Create a procedure to provide the name, size and their price when called upon using their name.

Drop procedure if exists input_name;

Delimiter $$ 
Create procedure input_name(in p_name varchar(100))
Begin 
	Select pt.name, p.size, p.price
    From pizza_types pt 
    join pizzas p
    on p.pizza_type_id = pt.pizza_type_id
    Where p_name = pt.name;
End $$
Delimiter ; 

-- Create a procedure uses CTE to provide the total order and their sales of each pizza based on their size. Have the list orderd by thier total sales.
Drop Procedure if exists input_name_sales_info;
Delimiter $$
Create procedure input_name_sales_info(in p_name varchar(100))
Begin 
	With total_orders (name, pizza_id, size, total_orders) as (
	SELECT 
		pt.name, p.pizza_id, p.size, sum(od.quantity) as total_orders
	FROM
		 orders o
			JOIN
		order_details od ON o.order_id = od.order_id
			JOIN
		pizzas p ON p.pizza_id = od.pizza_id
			JOIN
		pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
	GROUP BY pt.name, p.size, p.pizza_id
	ORDER BY pt.name  DESC)
	Select t_o.name,t_o.size, t_o.total_orders, (t_o.total_orders * sum(p.price)) as total_sales
	From total_orders t_o
	left join pizzas p
	on p.pizza_id = t_o.pizza_id
    where p_name = t_o.name
	GROUP BY t_o.size, t_o.pizza_id, t_o.name
	Order by total_sales desc;
End $$
Delimiter ; 

/* Having this procedure allows the pizza store to look up each pizza by thier name and see how much each pizza is being sold and 
how much sales the pizza is generating based on their size*/

-- Conclussion
/* Overall, through this exploration of this dataset, we can conclude that the store should most likly have extra employees on Friday around 12pm and 6pm because they are the busiest time of the week and day. 
The store doesn't need as much employees during opening and closing hours because those are the slowest time of the day.
We discovered that Classic pizzas are the highest selling pizzas, while suprising chicken was the least selling.
We also found that Large size pizzas are the top selling pizzas and if we were to create a new pizza, having a Classic large size pizza would be a good idea for more orders and sales. However,
XXL pizza didn't generate much sales so having a XXL size doesn't increase the sales as much. */

