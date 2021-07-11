
#Pizza Metrics
-- 1.How many pizzas were ordered?
SELECT COUNT(order_id) AS pizzasordered
FROM customer_orders;

-- 2 How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) AS Uniquecustomerorders
FROM customer_orders;

-- 3 How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS DeliveredOrders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4 How many of each type of pizza was delivered?
With
    pizzadelivery
    AS
    (
        SELECT
            co.pizza_id, IF(ro.cancellation IS NULL , "delivered", "not delivered" ) AS deliverystatus, ro.order_id
        FROM customer_orders co
    LEFT JOIN runner_orders AS ro ON co.order_id = ro.order_id)
SELECT pn.pizza_name, COUNT(pd.deliverystatus) AS PizzaDelivered
FROM pizzadelivery pd
    LEFT JOIN pizza_names AS pn ON pd.pizza_id = pn.pizza_id
WHERE deliverystatus = "delivered"
GROUP BY pizza_name;

-- 5 How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id AS Customers, COUNT(CASE WHEN pn.pizza_name = "MeatLovers" THEN "MeatLovers" END) AS "MeatLovers",
    COUNT(CASE WHEN pn.pizza_name = "Vegetarian" THEN "Vegetarian" END) AS "Vegetarian"
FROM customer_orders co
    JOIN Pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY customer_id;

-- 6.What was the maximum number of pizzas delivered in a single order?			
WITH
    pizzaorders
    AS
    (
        SELECT co.order_id, COUNT(co.Pizza_id) AS PizzaCount , DENSE_RANK() OVER(ORDER BY COUNT(co.pizza_id) DESC) AS Ranked
        FROM customer_orders co
            JOIN runner_orders ro ON co.order_id = ro.order_id
        WHERE cancellation IS NULL
        GROUP BY order_id
    )
SELECT order_id, PizzaCount
FROM pizzaorders po
WHERE Ranked = 1;

-- 7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
with
    changedpizzas
    AS
    (
        SELECT co.customer_id, co.order_id , CASE 
			WHEN co.exclusions IS NULL AND co.extras IS NULL THEN "NoChange"
            ELSE "HasChange"
            END ChangedPizzas
        FROM customer_orders co
            INNER JOIN runner_orders ro ON co.order_id = ro.order_id
        WHERE cancellation IS NULL OR cancellation = ""
    )
SELECT cp.customer_id AS Customer, COUNT(CASE WHEN Changedpizzas = "NoChange" THEN "No Changes" END) NoChanges,
    COUNT(CASE WHEN Changedpizzas = "HasChange" THEN "HasChanges" END) Hasatleast1Change
FROM changedpizzas cp
GROUP BY customer_id;

-- 8.How many pizzas were delivered that had both exclusions and extras?                      
with
    bothchanged
    AS
    (
        SELECT co.order_id, CASE 
					WHEN co.exclusions IS NOT NULL AND co.extras IS NOT NULL THEN "BothChanges"
                    WHEN co.exclusions IS NULL AND co.extras IS NOT NULL THEN "OneChange"
                    WHEN co.extras IS NULL AND co.exclusions IS NOT NULL THEN "OneChange"
					ELSE "HasNoChanges" 
                    END ExclusionsandExtras
        FROM customer_orders co
            INNER JOIN runner_orders ro ON co.order_id = ro.order_id
        WHERE cancellation IS NULL
    )
SELECT COUNT(*) AS PizzasDeliveredwithexclusions
FROM bothchanged
WHERE ExclusionsandExtras = "BothChanges";

-- 9.What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_time) AS HourofDay, COUNT(pizza_id) AS PizzaCount
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

-- 10 What was the volume of orders for each day of the week?
SELECT dayname(order_time) AS DayOfWeek, COUNT(pizza_id) AS PizzaCount
FROM customer_orders
GROUP BY  dayname(order_time)
ORDER BY dayname(order_time) DESC;









  


