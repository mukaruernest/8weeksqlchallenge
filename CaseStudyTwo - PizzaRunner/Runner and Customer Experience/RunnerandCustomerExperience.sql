
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date, 2) AS Weekly, COUNT(runner_id) AS RunnerCount
FROM runners
GROUP BY WEEK(registration_date);

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT CEILING(AVG(MINUTE(ro.pickup_time) - MINUTE(co.order_time))) AS AverageMinutes
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
/*No there is No relationship*/
SELECT co.Pizza_id, CEILING(AVG(MINUTE(ro.pickup_time) - MINUTE(co.order_time))) AS AverageMakingTime, COUNT(co.order_id) AS NumberOfPizzas
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id
GROUP BY co.pizza_id;

-- 4. What was the average distance travelled for each customer?
SELECT co.customer_id, ROUND(AVG(ro.distance),2) AS AverageDistanceTraveled
FROM customer_orders co
    INNER JOIN runner_orders ro ON co.order_id = ro.order_id
GROUP BY customer_id;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT CONCAT(MAX(duration) - MIN(duration), " minutes") AS DifferenceBtwnLongestandShortest
FROM runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id, CONCAT(FLOOR(AVG(distance/ (duration/60))), " KM/h") AS AverageSpeed , order_id
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id, order_id;

-- 7. What is the successful delivery percentage for each runner?
SELECT runner_id, CONCAT(COUNT(CASE WHEN cancellation IS NULL THEN "DELIVERED" END)/COUNT(order_id)*100, "%" )AS PercentageDelivered
FROM runner_orders
GROUP BY runner_id;
 

