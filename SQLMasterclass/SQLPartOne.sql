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

--INSERT
INSERT INTO customers
VALUES 
    (DEFAULT, 
    'Jhon', 
    'Smith',
    '1990-01-01',
    Null,
    'address',
    'city',
    'CA',
    DEFAULT)

--Create Archived table
CREATE TABLE orders_archived
SELECT * FROM orders

--Copy Table for archive 
INSERT INTO orders_archived
SELECT *
From orders
Where order_date < '2019-01-01'

--UPDATE invoices
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice id = 1

--UPDATE multiple roads invoices
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE client_id IN (3,4)

--SUBQUERIES 
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice id = (SELECT client_id 
                    FROM clients 
                    WHERE state IN ('CA', 'NY'))

--SUBQUERIES NOT IN
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice id NOT IN (SELECT client_id 
                    FROM clients 
                    WHERE state IN ('CA', 'NY'))

--DELETE 
DELETE FROM invoices
WHERE invoice_id = 1

--Aggregate Functions (MAX, MIN, AVG, SUM, COUNT)
SELECT 
    MAX(invoice_total) AS highest
FROM invoices

--GROUP BY
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id

--HAVING: you can use HAVING as a WHERE after a GROUP BY

--GROUP BY with ROLLUP
SELECT 
	client_id, 
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP

--Common Functions: ROUND(), CEILING(), TRUNCATE(), FLOOR(), ABS(), RAND()
--String Functions: LENGTH('example'),...
--Date Functions: NOW(), CURDATE(),...
--Formating Dates F: DATE_FORMAT(NOW(), '%M %d %Y')
--Calculating Dates and Time DATE_ADD(NOW(), INTERVAL 1 DAY)
--IFNUL and COALESCE Func: IFNULL(shiper_id, 'Not Assigned')
--IF Func: IF(expression, first, second)
--CASE Operator: CASE WHEN ... WHEN ...
-- = ANY is equal to IN operatior
-- EXIST is more efficient than IN
-- You can use sub queries for SELECT and FROM