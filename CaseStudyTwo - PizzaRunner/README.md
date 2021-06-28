## Case Study Info

This case study has LOTS of questions - they are broken up by area of focus including:

- [Pizza Metrics](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudyTwo%20-%20PizzaRunner/Pizza%20Metrics)
- [Runner and Customer Experience](https://github.com/mukaruernest/8weeksqlchallenge/tree/master/CaseStudyTwo%20-%20PizzaRunner/Runner%20and%20Customer%20Experience) 
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML - Data Manipulation Language)

Before writing SQL queries however - Investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

``` SQL
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = "" THEN NULL ELSE exclusions END,
	extras = CASE WHEN extras = "" THEN NULL ELSE extras END;
```

There are some known data issues with runner_orders table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

``` SQL
UPDATE runner_orders 
SET cancellation = CASE WHEN cancellation = "" THEN NULL ELSE cancellation END;
```
