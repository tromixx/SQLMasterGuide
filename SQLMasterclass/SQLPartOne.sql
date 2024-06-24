---USE sql_store;

SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE state = 'VA'


--More generic stuff
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE birth_date > '1990-01-01' or points > 1000


--In operator
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE state IN ('GA', 'VA')


--Between operator
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE points BETWEEN 1000 and 3000

--Like operator
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE last_name LIKE ('b%') or ('b____y')

--REGEXP operator
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
WHERE last_name REGEXP ('[a-h]e')

--ORDER BY
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
ORDER BY discount

--LIMIT
SELECT 
	last_name, 
    points + 100 AS discount
FROM customers
LIMIT 300

--Inner Join
SELECT order_id, o.customer_id, first_name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id

--Joining 3 tables
SELECT *
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	on p.payment_method = pm.payment_method_id

--Joining 3 tables
SELECT 
	p.date,
    p.invoice_id,
    c.name,
    pm.name
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	on p.payment_method = pm.payment_method_id

--Outer Join (Left, Right Join)
SELECT 
    p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id

--USING to replace ON
SELECT *
FROM orders o
JOIN customers c
    USING (customer_id)

--UNION
SELECT name AS full_name
FROM shippers
UNION
SELECT first_name
FROM customers