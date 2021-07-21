# Case Study Two - Runner and Customer Experience

## Table of Contents
- [Introduction](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudy2%20-%20PizzaRunner/Runner%20and%20Customer%20Experience#introduction)
- [Datasets](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudy2%20-%20PizzaRunner/Runner%20and%20Customer%20Experience#datasets)
- [Case Study Questions](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudy2%20-%20PizzaRunner/Runner%20and%20Customer%20Experience#case-study-questions)
- [Solutions](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudy2%20-%20PizzaRunner/Runner%20and%20Customer%20Experience#solution)

## Introduction 

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers

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

<details>
  <summary>Cleaned customer_orders Table</summary>
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
</details>
    
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

<details>
  <summary>Cleaned runner_orders table</summary>
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
</details>

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

## Case Study Questions

1.   How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2.   What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3.   Is there any relationship between the number of pizzas and how long the order takes to prepare?
4.   What was the average distance travelled for each customer?
5.   What was the difference between the longest and shortest delivery times for all orders?
6.   What was the average speed for each runner for each delivery and do you notice any trend for these values?
7.   What is the successful delivery percentage for each runner?

## Solution

Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```SQL
SELECT WEEK(registration_date, 2) AS Weekly, COUNT(runner_id) AS RunnerCount
FROM runners
GROUP BY WEEK(registration_date);
```
| Weekly | RunnerCount |
|--------|-------------|
| 52     |      1      |
| 1      |      2      |
| 2      |      1      |

Q2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```SQL
SELECT CEILING(AVG(MINUTE(ro.pickup_time) - MINUTE(co.order_time))) AS AverageMinutes
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id;
```
| # AverageMinutes |
|------------------|
|          4                |

Q3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
/*No there is No relationship*/
```SQL
SELECT co.Pizza_id, CEILING(AVG(MINUTE(ro.pickup_time) - MINUTE(co.order_time))) AS AverageMakingTime, COUNT(co.order_id) AS NumberOfPizzas
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id
GROUP BY co.pizza_id;
```
| # Pizza_id | AverageMakingTime | NumberOfPizzas |
|:----------:|:-----------------:|:--------------:|
|      1     |         5         |       10       |
|      2     |         1         |        4       |

Q4. What was the average distance travelled for each customer?
```SQL
SELECT co.customer_id, ROUND(AVG(ro.distance),2) AS AverageDistanceTraveled
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id
GROUP BY customer_id;
```
| # customer_id | AverageDistanceTraveled |
|:-------------:|:-----------------------:|
|      101      |            20           |
|      102      |          16.73          |
|      103      |           23.4          |
|      104      |            10           |
|      105      |            25           |

Q5. What was the difference between the longest and shortest delivery times for all orders?
```SQL
SELECT CONCAT(MAX(duration) - MIN(duration), " minutes") AS DifferenceBtwnLongestandShortest
FROM runner_orders;
```
| DifferenceBtwnLongestandShortest |
|:--------------------------------:|
|            30 minutes            |

Q6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```SQL
SELECT runner_id, CONCAT(FLOOR(AVG(distance/ (duration/60))), " KM/h") AS AverageSpeed , order_id
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id, order_id;
```
| # runner_id | AverageSpeed | order_id |
|:-----------:|:------------:|:--------:|
|      1      |    37 KM/h   |     1    |
|      1      |    44 KM/h   |     2    |
|      1      |    40 KM/h   |     3    |
|      2      |    35 KM/h   |     4    |
|      3      |    40 KM/h   |     5    |
|      2      |    60 KM/h   |     7    |
|      2      |    93 KM/h   |     8    |
|      1      |    60 KM/h   |    10    |

Q 7. What is the successful delivery percentage for each runner?
```SQL
SELECT runner_id, CONCAT(COUNT(CASE WHEN cancellation IS NULL THEN "DELIVERED" END)/COUNT(order_id)*100, "%" )AS PercentageDelivered
FROM runner_orders
GROUP BY runner_id;
```
| # runner_id | PercentageDelivered |
|:-----------:|:-------------------:|
|      1      |      100.0000%      |
|      2      |       75.0000%      |
|      3      |       50.0000%      |

