# Case Study One - Danny's Diner

## Introduction

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

## DataSets

**Table 1: Sales**

The sales table captures all `customer_id` level purchases with an corresponding `order_date` and `product_id` information for when and what menu items were ordered.

<html><body>
<!--StartFragment-->

customer_id | order_date | product_id
-- | -- | --
A | 2021-01-01 | 1
A | 2021-01-01 | 2
A | 2021-01-07 | 2
A | 2021-01-10 | 3
A | 2021-01-11 | 3
A | 2021-01-11 | 3
B | 2021-01-01 | 2
B | 2021-01-02 | 2
B | 2021-01-04 | 1
B | 2021-01-11 | 1
B | 2021-01-16 | 3
B | 2021-02-01 | 3
C | 2021-01-01 | 3
C | 2021-01-01 | 3
C | 2021-01-07 | 3

<!--EndFragment-->
</body>
</html>

**Table 2: Menu**

The menu table maps the `product_id` to the actual `product_name` and `price` of each menu item.

<html><body>
<!--StartFragment-->

product_id | product_name | price
-- | -- | --
1 | sushi | 10
2 | curry | 15
3 | ramen | 12

<!--EndFragment-->
</body>
</html>

**Table 3: Members**

The final `members` table captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.

<html><body>
<!--StartFragment-->

customer_id | join_date
-- | --
A | 2021-01-07
B | 2021-01-09

<!--EndFragment-->
</body>
</html>

### Case Study Questions

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


## Solution


1.What is the total amount each customer spent at the restaurant?

``` SQL
SELECT sales.customer_id, SUM(menu.price)
FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id;
```

2. How many days has each customer visited the restaurant?

``` SQL
SELECT Customer_id, COUNT(DISTINCT(order_date)) AS NumberofVisits
FROM sales
GROUP BY customer_id;
```

3. What was the first item from the menu purchased by each customer?

``` SQL
with
    first_date
    AS
    (
        SELECT min(order_date) AS firstorderdate
        FROM sales
    )
SELECT
    customer_id, firstorderdate, product_name
FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
    INNER JOIN first_date ON sales.order_date = first_date.firstorderdate
GROUP BY customer_id;
```

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

``` SQL
SELECT menu.product_name, COUNT(sales.product_id) AS Timespurchased
FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY Timespurchased DESC
LIMIT 1;
```

5. Which item was the most popular for each customer?

``` SQL
SELECT
    sales.customer_id,
    menu.product_name,
    COUNT(*) AS purchases
FROM sales
    LEFT JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY sales.customer_id, menu.product_name
ORDER BY sales.customer_id, purchases DESC;
```

6. Which item was purchased first by the customer after they became a member?

``` SQL
with
    purchasetable
    AS
    (
        SELECT sales.customer_id, sales.product_id, DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) AS SaleRank, sales.order_date
        FROM sales
            LEFT JOIN members
            ON sales.customer_id = members.customer_id
        WHERE sales.order_date >= members.join_date
    )
SELECT p.customer_id, menu.product_name
FROM purchasetable p
    JOIN menu ON p.product_id = menu.product_id
WHERE SaleRank = 1;
```

7. Which item was purchased just before the customer became a member?

``` SQL
with
    purchasetable
    AS
    (
        SELECT sales.customer_id, sales.product_id, DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) AS SaleRank, sales.order_date
        FROM sales
            LEFT JOIN members
            ON sales.customer_id = members.customer_id
        WHERE sales.order_date < members.join_date
    )
SELECT p.customer_id, menu.product_name
FROM purchasetable p
    JOIN menu ON p.product_id = menu.product_id
WHERE SaleRank = 1;
```

8. What is the total items and amount spent for each member before they became a member?

``` SQL
with
    beforemembership
    AS
    (
        SELECT sales.customer_id, sales.product_id, sales.order_date
        FROM sales
            LEFT JOIN members
            ON sales.customer_id = members.customer_id
        WHERE sales.order_date < members.join_date
    )
SELECT b.customer_id, COUNT(b.product_id) AS TotalItems, SUM(menu.price) AS AmountSpent
FROM beforemembership b
    LEFT JOIN menu ON b.product_id = menu.product_id
GROUP BY customer_id;
```

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

``` SQL
SELECT sales.customer_id, menu.price, SUM(
IF(sales.product_id = 1, menu.price * 2, menu.price * 1 )) AS points
FROM sales
LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY Customer_id;
```

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi    how many points do customer A and B have at the end of January?

``` SQL
WITH
    member_order_points
    AS
    (
        SELECT
            sales.customer_id,
            sales.order_date,
            members.join_date,
            menu.product_name,
            menu.price,
            CASE WHEN sales.order_date >= members.join_date
                AND sales.order_date < members.join_date + 7 THEN 2*menu.price
             WHEN menu.product_name = 'sushi' THEN 2*menu.price
        ELSE menu.price END AS points
        FROM sales
            LEFT JOIN menu
            ON sales.product_id = menu.product_id
            INNER JOIN members
            ON sales.customer_id = members.customer_id
    )

SELECT
    customer_id,
    SUM(points)
FROM member_order_points AS mop
WHERE order_date <= '2021-01-31'
GROUP BY customer_id
ORDER BY customer_id;
```
