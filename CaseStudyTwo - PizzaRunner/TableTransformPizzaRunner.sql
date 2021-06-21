/*Data Cleaning*/
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = "" THEN NULL ELSE exclusions END,
	extras = CASE WHEN extras = "" THEN NULL ELSE extras END;

