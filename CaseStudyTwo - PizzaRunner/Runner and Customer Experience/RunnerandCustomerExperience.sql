/* 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
    How many pizzas were ordered?
    How many unique customer orders were made?
    How many successful orders were delivered by each runner?
    How many of each type of pizza was delivered?
    How many Vegetarian and Meatlovers were ordered by each customer?
    What was the maximum number of pizzas delivered in a single order?
    For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
    How many pizzas were delivered that had both exclusions and extras?
    What was the total volume of pizzas ordered for each hour of the day?
    What was the volume of orders for each day of the week?
*/
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date, 2) AS Weekly, COUNT(runner_id) AS RunnerCount
FROM runners
GROUP BY WEEK(registration_date)

-- How many pizzas were ordered?


