-- Retrieve the total number of orders placed.
select count(*) as total_orders 
from orders;

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales
FROM order_details JOIN pizzas 
ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
SELECT p.price, pt.name
FROM pizzas AS p JOIN pizza_types AS pt 
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT p.size, COUNT(o.order_details_id) AS Most_common
FROM pizzas AS p JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY Most_common DESC
LIMIT 1;

SELECT p.size
FROM pizzas AS p
GROUP BY p.size
ORDER BY size
LIMIT 1;

-- List the top 5 most ordered pizza types
-- along with their quantities.
SELECT p.pizza_type_id, COUNT(o.quantity)
FROM pizzas AS p JOIN order_details AS o 
ON p.pizza_id = o.pizza_id
GROUP BY p.pizza_type_id
ORDER BY p.pizza_type_id
LIMIT 5;

-- Join the necessary tables to find the total quantity 
-- of each pizza category ordered.
SELECT pt.category, SUM(o.quantity) AS quantity
FROM pizza_types AS pt
JOIN pizzas AS p 
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS o ON o.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS hour, COUNT(order_id)
FROM orders
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise
-- distribution of pizzas.
select category, count(name) 
from pizza_types
group by category;

-- Group the orders by date and calculate the average 
-- number of pizzas ordered per day.
select round(avg(quantity),0) as avg_pizza_ordered_per_day
 from
(select o.order_date, sum(od.quantity)
from orders as o join order_details as od
on o.order_id = od.order_id
group by o.order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pt.name,sum(o.quantity * p.price) as revenue
from pizza_types as pt join pizzas as p
on pt.pizza_type_id = p.pizza_type_id 
join order_details as o
on o.pizza_id= p.pizza_id
group by pt.name 
order by revenue desc
limit 3;

-- Calculate the percentage contribution of 
-- each pizza type to total revenue.
select pt.category,
 round(sum(od.quantity * p.price) / (select 
 round(sum(od.quantity*p.price),2) as total_sales
from  order_details as od join pizzas as p 
on od.pizza_id = p.pizza_id )*100,2) as revenue
from pizza_types as pt join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od 
on od.pizza_id = p.pizza_id 
group by pt.category 
order by revenue desc;

-- Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over (order by order_date) as cum_revnue
from
(select o.order_date ,
sum(od.quantity * p.price) as revenue
from order_details as od join pizzas as p 
on od.pizza_id = p.pizza_id 
join
orders as o
 on o.order_id = od.order_id 
 group by o.order_date ) as sales;

-- Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.
select 
pt.category, pt.name,
sum((od.quantity) * p.price) as revenue
from pizza_types as pt join pizzas as p 
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id 
group by pt.category ,pt.name 
order by revenue desc
limit 3;









