# Case Study One - Foodie - Fi


## Table of Content

- [Introduction](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudy3%20-%20Foodie-Fie/README.md#introduction)
- [Problem Statement](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudy3%20-%20Foodie-Fie/README.md#problem-statement)
- [DataSets](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudy3%20-%20Foodie-Fie/README.md#datasets)
- [Case Study Questions](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudy3%20-%20Foodie-Fie/README.md#case-study-questions)
- [Solutions](https://github.com/mukaruernest/8weeksqlchallenge/blob/master/CaseStudy3%20-%20Foodie-Fie/README.md#solution)


![image](https://user-images.githubusercontent.com/10958742/129623791-bc1d067a-4eb5-4efc-99b1-242ec9557769.png)


# Introduction

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

# Problem Statement

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

# DataSets

**Table 1: plans**

Customers can choose which plans to join Foodie-Fi when they first sign up.

Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they decide otherwise.

When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

| plan_id | plan_name     | price |
|---------|---------------|-------|
| 0       | trial         | 0     |
| 1       | basic monthly | 9.90  |
| 2       | pro monthly   | 19.90 |
| 3       | pro annual    | 199   |
| 4       | churn         | null  |

**Table 2: subscriptions**

Customer subscriptions show the exact date where their specific plan_id starts. 

This is only part of the table to see the whole datble check the schema file. 

| customer_id | plan_id | start_date |
|-------------|---------|------------|
| 1           | 0       | 2020-08-01 |
| 1           | 1       | 2020-08-08 |
| 2           | 0       | 2020-09-20 |
| 2           | 3       | 2020-09-27 |
| 11          | 0       | 2020-11-19 |
| 11          | 4       | 2020-11-26 |


# Case Study Questions

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

# Solution

1.  How many customers has Foodie-Fi ever had?

```SQL
 SELECT COUNT(DISTINCT customer_id) AS TotalCustomers
 FROM foodie_fi.subscriptions; 
```
 
2.  What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```SQL
SELECT
  EXTRACT(MONTH FROM start_date) AS month_start,
  COUNT(*) AS trial_customers
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY month_start
ORDER BY month_start;
```
 
3.  What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

```SQL
SELECT p.plan_id, p.plan_name, COUNT(*) AS TotalCount
FROM foodie_fi.subscriptions s
INNER JOIN foodie_fi.plans p ON s.plan_id = p.plan_id
WHERE EXTRACT(YEAR FROM start_date) > 2020  
GROUP BY  p.plan_id, plan_name
ORDER BY plan_id;
```

4.  What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```SQL
SELECT
(SELECT COUNT(DISTINCT customer_id) 
FROM subscriptions
WHERE plan_id = 4) AS CustomerCount,
round(SUM(CASE WHEN plan_id = 4 THEN 1 END)/COUNT(DISTINCT customer_id) * 100 , 1) AS percentage
FROM subscriptions;
```

5.  How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?


