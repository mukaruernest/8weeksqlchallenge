## Case Study Info

This case study has LOTS of questions - they are broken up by area of focus including:

- [Pizza Metrics](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics)
- [Runner and Customer Experience](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudyTwo%20-%20PizzaRunner/Runner%20and%20Customer%20Experience) 
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML - Data Manipulation Language)

Before writing SQL queries however - Investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

Removing empty rows and replacing them with `NULL`  on `customer_orders` table
``` SQL
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = "" THEN NULL ELSE exclusions END,
	extras = CASE WHEN extras = "" THEN NULL ELSE extras END;
```

**Table: customer_orders**
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

There are some known data issues with runner_orders table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

Removing empty rows and replacing them with `null`  on `runner_orders ` table
``` SQL
UPDATE runner_orders 
SET cancellation = CASE WHEN cancellation = "" THEN NULL ELSE cancellation END;
```

**Table: runner_orders**
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


