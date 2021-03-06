/*
    What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
    How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
    What is the number and percentage of customer plans after their initial free trial?
    What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
    How many customers have upgraded to an annual plan in 2020?
    How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
    Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
    How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
*/
-- 1.  How many customers has Foodie-Fi ever had?
 SELECT COUNT(DISTINCT customer_id) AS TotalCustomers
 FROM foodie_fi.subscriptions; 
 
 -- 2 What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT
  EXTRACT(MONTH FROM start_date) AS month_start,
  COUNT(*) AS trial_customers
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY month_start
ORDER BY month_start;
 
 -- 3 What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT p.plan_id, p.plan_name, COUNT(*) AS TotalCount
FROM foodie_fi.subscriptions s
INNER JOIN foodie_fi.plans p ON s.plan_id = p.plan_id
WHERE EXTRACT(YEAR FROM start_date) > 2020  
GROUP BY  p.plan_id, plan_name
ORDER BY plan_id;

-- 4 What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT
(SELECT COUNT(DISTINCT customer_id) 
FROM foodie_fi.subscriptions
WHERE plan_id = 4) AS CustomerCount,
ROUND(100 * SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END)/CAST(COUNT(DISTINCT customer_id) AS DECIMAL) , 1) AS percentage
FROM foodie_fi.subscriptions;

-- 5 How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH ranked_plans AS (
  SELECT
    customer_id,
    plan_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY start_date ASC
    ) AS plan_rank
  FROM foodie_fi.subscriptions
)
SELECT
  SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END) AS churn_customers,
  ROUND(
    100 * SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END) /
    COUNT(*)
  ) AS percentage
FROM ranked_plans
WHERE plan_rank = 2;


 