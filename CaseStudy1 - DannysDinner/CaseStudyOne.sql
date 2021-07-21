-- 1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, SUM(menu.price) AS Total
FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT Customer_id, COUNT(DISTINCT(order_date)) AS NumberofVisits
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
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

-- 4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) AS Timespurchased
FROM sales
    LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY Timespurchased DESC 
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH ordercount AS
(SELECT
    sales
.customer_id,
    menu.product_name,
    COUNT(*) AS purchases
FROM sales
LEFT JOIN menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id, menu.product_name),
oderranking AS
(SELECT customer_id, product_name, purchases, RANK() OVER(PARTITION BY customer_id ORDER BY purchases DESC) AS Ranking
FROM ordercount)
SELECT * 
FROM oderranking
WHERE Ranking = 1; 

-- 6. Which item was purchased first by the customer after they became a member?
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

-- 7.Which item was purchased just before the customer became a member?
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
 
-- 8.What is the total items and amount spent for each member before they became a member?
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

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT sales.customer_id,
	SUM(CASE 
		WHEN sales.product_id = 1 THEN (menu.price * 20)
        ELSE menu.price * 10
        END) AS Points
FROM sales
LEFT JOIN menu ON sales.product_id = menu.product_id
GROUP BY Customer_id;

-- 10  In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
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

	
	





