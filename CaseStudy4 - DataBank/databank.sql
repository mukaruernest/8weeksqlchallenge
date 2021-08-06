/*
    A. Customer Nodes Exploration
    How many unique nodes are there on the Data Bank system?
    What is the number of nodes per region?
    How many customers are allocated to each region?
    How many days on average are customers reallocated to a different node?
    What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
*/

-- How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS Uniquedatanodes
FROM data_bank.customer_nodes;

-- What is the number of nodes per region?
SELECT r.region_name, COUNT(n.node_Id) AS NodeCount
FROM data_bank.customer_nodes n
    INNER JOIN data_bank.regions r ON n.region_id = r.region_id
GROUP BY r.region_name;

-- How many customers are allocated to each region?
SELECT region_id, COUNT(customer_id) AS customercount
FROM data_bank.customer_nodes
GROUP BY region_id;

-- How many days on average are customers reallocated to a different node?
SELECT AVG(date_part('day', end_date) - date_part('day', start_date)) AS Averagedays
FROM data_bank.customer_nodes

-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
[UPDATING]
