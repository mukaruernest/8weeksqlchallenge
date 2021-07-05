# Case Study Two - Pizza Runner

Table of Contents
- [Introduction](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics/README.md#introduction)
- [Datasets](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics/README.md#datasets)
- [Case Study Questions](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics/README.md#case-study-questions)
- [Solutions](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics/README.md#solution)

## Introduction 

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Datasets

**Table 1: Runners**

The `runners` table shows the `registration_date` for each new runner

<html><body>
<!--StartFragment-->

runner_id | registration_date
-- | --
1 | 2021-01-01
2 | 2021-01-03
3 | 2021-01-08
4 | 2021-01-15

<!--EndFragment-->
</body>
</html>

**Table 2: customer_orders**

Customer pizza orders are captured in the `customer_orders` table with 1 row for each individual pizza that is part of the order.

The `pizza_id` relates to the type of pizza which was ordered whilst the `exclusions` are the `ingredient_id` values which should be removed from the pizza and the `extras` are the `ingredient_id` values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying `exclusions` and `extras` values even if the pizza is the same type!

The `exclusions` and `extras` columns will need to be cleaned up before using them in your queries.


<html><body>
<!--StartFragment-->

order_id | customer_id | pizza_id | exclusions | extras | order_time
-- | -- | -- | -- | -- | --
1 | 101 | 1 |   |   | 2021-01-01 18:05:02
2 | 101 | 1 |   |   | 2021-01-01 19:00:52
3 | 102 | 1 |   |   | 2021-01-02 23:51:23
3 | 102 | 2 |   | NaN | 2021-01-02 23:51:23
4 | 103 | 1 | 4 |   | 2021-01-04 13:23:46
4 | 103 | 1 | 4 |   | 2021-01-04 13:23:46
4 | 103 | 2 | 4 |   | 2021-01-04 13:23:46
5 | 104 | 1 | null | 1 | 2021-01-08 21:00:29
6 | 101 | 2 | null | null | 2021-01-08 21:03:13
7 | 105 | 2 | null | 1 | 2021-01-08 21:20:29
8 | 102 | 1 | null | null | 2021-01-09 23:54:33
9 | 103 | 1 | 4 | 1, 5 | 2021-01-10 11:22:59
10 | 104 | 1 | null | null | 2021-01-11 18:34:49
10 | 104 | 1 | 2, 6 | 1, 4 | 2021-01-11 18:34:49

<!--EndFragment-->
</body>
</html>

Cleaned customer_orders Table

<html><body>
<!--StartFragment-->

order_id | customer_id | pizza_id | exclusions | extras | order_time
-- | -- | -- | -- | -- | --
1 | 101 | 1 | null |  null | 2021-01-01 18:05:02
2 | 101 | 1 |  null |null | 2021-01-01 19:00:52
3 | 102 | 1 | null | null | 2021-01-02 23:51:23
3 | 102 | 2 |  null | null | 2021-01-02 23:51:23
4 | 103 | 1 | 4 |  null | 2021-01-04 13:23:46
4 | 103 | 1 | 4 | null | 2021-01-04 13:23:46
4 | 103 | 2 | 4 |  null | 2021-01-04 13:23:46
5 | 104 | 1 | null | 1 | 2021-01-08 21:00:29
6 | 101 | 2 | null | null | 2021-01-08 21:03:13
7 | 105 | 2 | null | 1 | 2021-01-08 21:20:29
8 | 102 | 1 | null | null | 2021-01-09 23:54:33
9 | 103 | 1 | 4 | 1, 5 | 2021-01-10 11:22:59
10 | 104 | 1 | null | null | 2021-01-11 18:34:49
10 | 104 | 1 | 2, 6 | 1, 4 | 2021-01-11 18:34:49

<!--EndFragment-->
</body>
</html>

**Table 3: Runner_orders**

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The `pickup_time` is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The `distance` and `duration` fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

<html><body>
<!--StartFragment-->

order_id | runner_id | pickup_time | distance | duration | cancellation
-- | -- | -- | -- | -- | --
1 | 1 | 2021-01-01 18:15:34 | 20km | 32 minutes |  
2 | 1 | 2021-01-01 19:10:54 | 20km | 27 minutes |  
3 | 1 | 2021-01-03 00:12:37 | 13.4km | 20 mins | NaN
4 | 2 | 2021-01-04 13:53:03 | 23.4 | 40 | NaN
5 | 3 | 2021-01-08 21:10:57 | 10 | 15 | NaN
6 | 3 | null | null | null | Restaurant Cancellation
7 | 2 | 2020-01-08 21:30:45 | 25km | 25mins | null
8 | 2 | 2020-01-10 00:15:02 | 23.4 km | 15 minute | null
9 | 2 | null | null | null | Customer Cancellation
10 | 1 | 2020-01-11 18:50:20 | 10km | 10minutes | null

<!--EndFragment-->
</body>
</html>

Cleaned runner_orders table

<html><body>
<!--StartFragment-->

order_id | runner_id | pickup_time | distance | duration | cancellation
-- | -- | -- | -- | -- | --
1 | 1 | 2021-01-01 18:15:34 | 20km | 32 minutes |  null 
2 | 1 | 2021-01-01 19:10:54 | 20km | 27 minutes |  null 
3 | 1 | 2021-01-03 00:12:37 | 13.4km | 20 mins | NaN
4 | 2 | 2021-01-04 13:53:03 | 23.4 | 40 | NaN
5 | 3 | 2021-01-08 21:10:57 | 10 | 15 | NaN
6 | 3 | null | null | null | Restaurant Cancellation
7 | 2 | 2020-01-08 21:30:45 | 25km | 25mins | null
8 | 2 | 2020-01-10 00:15:02 | 23.4 km | 15 minute | null
9 | 2 | null | null | null | Customer Cancellation
10 | 1 | 2020-01-11 18:50:20 | 10km | 10minutes | null

<!--EndFragment-->
</body>
</html>

**Table 4: pizza_names**

At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

<html><body>
<!--StartFragment-->

pizza_id | pizza_name
-- | --
1 | Meat Lovers
2 | Vegetarian

<!--EndFragment-->
</body>
</html>

### Case Study Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

### Solution

1. How many pizzas were ordered?

``` SQL
SELECT COUNT(order_id) AS pizzasordered
FROM customer_orders;
```

2. How many unique customer orders were made?

``` SQL
SELECT COUNT(DISTINCT(order_id)) AS Uniquecustomerorders
FROM customer_orders;
```

3. How many successful orders were delivered by each runner?

``` SQL
SELECT runner_id, COUNT(order_id) AS DeliveredOrders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
```

4. How many of each type of pizza was delivered?

``` SQL
With
    pizzadelivery
    AS
    (
        SELECT co.pizza_id, 
    
IF(ro.cancellation IS NULL , "delivered", "not delivered" ) AS deliverystatus, ro.order_id
FROM customer_orders co
LEFT JOIN runner_orders AS ro ON co.order_id = ro.order_id)
SELECT pn.pizza_name, COUNT(pd.deliverystatus) AS PizzaDelivered
FROM pizzadelivery pd
    LEFT JOIN pizza_names AS pn ON pd.pizza_id = pn.pizza_id
WHERE deliverystatus = "delivered"
GROUP BY pizza_name;
```

5. How many Vegetarian and Meatlovers were ordered by each customer?

``` SQL
SELECT co.customer_id AS Customers, COUNT(CASE WHEN pn.pizza_name = "MeatLovers" THEN "MeatLovers" END) AS "MeatLovers", COUNT(CASE WHEN pn.pizza_name = "Vegetarian" THEN "Vegetarian" END) AS "Vegetarian"
FROM customer_orders co
    JOIN Pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY customer_id;
```

6. What was the maximum number of pizzas delivered in a single order?

``` SQL
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
```

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

``` SQL
with
    changedpizzas
    AS
    (
        SELECT co.customer_id, co.order_id ,
            CASE 
      WHEN co.exclusions IS NULL AND co.extras IS NULL THEN "NoChange"
      ELSE "HasChange"
      END ChangedPizzas
        FROM customer_orders co
            INNER JOIN runner_orders ro ON co.order_id = ro.order_id
        WHERE cancellation IS NULL OR cancellation = ""
    )
SELECT cp.customer_id AS Customer,
    COUNT(CASE WHEN Changedpizzas = "NoChange" THEN "No Changes" END) NoChanges,
    COUNT(CASE WHEN Changedpizzas = "HasChange" THEN "HasChanges" END) Hasatleast1Change
FROM changedpizzas cp
GROUP BY customer_id;
```

8. How many pizzas were delivered that had both exclusions and extras?

``` SQL
with
    bothchanged
    AS
    (
        SELECT co.order_id,
            CASE 
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
```

9. What was the total volume of pizzas ordered for each hour of the day?

``` SQL
SELECT HOUR(order_time) AS HourofDay, COUNT(pizza_id) AS PizzaCount
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);
```

10. What was the volume of orders for each day of the week?

``` SQL
SELECT dayname(order_time) AS DayOfWeek, COUNT(pizza_id) AS PizzaCount
FROM customer_orders
GROUP BY  dayname(order_time)
ORDER BY dayname(order_time) DESC;
```
