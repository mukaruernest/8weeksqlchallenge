/*Data Cleaning Customer_orders Table*/
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = "" THEN NULL ELSE exclusions END,
	extras = CASE WHEN extras = "" THEN NULL ELSE extras END;

/*Data Cleaning runner_orders table*/    
UPDATE runner_orders 
SET cancellation = CASE WHEN cancellation = "" THEN NULL ELSE cancellation END;


