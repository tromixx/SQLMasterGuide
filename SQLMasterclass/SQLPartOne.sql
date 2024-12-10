-- ========================
-- SQL Comprehensive Guide
-- ========================

-- ========================
-- Section 1: Introduction
-- ========================
-- USE DATABASE
USE sql_store;

-- ========================
-- Section 2: SQL Basics
-- ========================

-- SELECT Statement
SELECT last_name, points + 100 AS discount
FROM customers
WHERE state = 'VA';

-- Using WHERE with Logical Operators
SELECT last_name, points + 100 AS discount
FROM customers
WHERE birth_date > '1990-01-01' OR points > 1000;

-- IN Operator
SELECT last_name, points + 100 AS discount
FROM customers
WHERE state IN ('GA', 'VA');

-- BETWEEN Operator
SELECT last_name, points + 100 AS discount
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- LIKE Operator
SELECT last_name, points + 100 AS discount
FROM customers
WHERE last_name LIKE 'b%' OR last_name LIKE 'b____y';

-- REGEXP Operator
SELECT last_name, points + 100 AS discount
FROM customers
WHERE last_name REGEXP '[a-h]e';

-- ORDER BY Clause
SELECT last_name, points + 100 AS discount
FROM customers
ORDER BY discount;

-- LIMIT Clause
SELECT last_name, points + 100 AS discount
FROM customers
LIMIT 300;

-- ==============================
-- Section 3: Database Modeling
-- ==============================

-- Entity Relationship Example: Inner Join
SELECT order_id, o.customer_id, first_name
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

-- Joining Multiple Tables
SELECT p.date, p.invoice_id, c.name AS client_name, pm.name AS payment_method
FROM payments p
JOIN clients c
    ON p.client_id = c.client_id
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id;

-- LEFT JOIN Example
SELECT p.product_id, p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id;

-- Using USING to Replace ON
SELECT *
FROM orders o
JOIN customers c
    USING (customer_id);

-- UNION Example
SELECT name AS full_name
FROM shippers
UNION
SELECT first_name
FROM customers;

-- ========================
-- Section 4: CRUD Queries
-- ========================

-- INSERT Statement
INSERT INTO customers
VALUES 
(DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'CA', DEFAULT);

-- UPDATE Statement
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1;

-- DELETE Statement
DELETE FROM invoices
WHERE invoice_id = 1;

-- ========================
-- Section 5: Advanced SQL
-- ========================

-- Subqueries in WHERE Clause
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE client_id IN (
    SELECT client_id
    FROM clients
    WHERE state IN ('CA', 'NY')
);

-- Aggregate Functions (MAX, MIN, AVG, SUM, COUNT)
SELECT MAX(invoice_total) AS highest_total
FROM invoices;

-- GROUP BY with Aggregate Functions
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id;

-- GROUP BY with ROLLUP
SELECT client_id, SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;

-- Window Functions
SELECT first_name, salary, RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees;

-- ================================
-- Section 6: Indexes and Views
-- ================================

-- Index Example
CREATE INDEX idx_employee_name ON Employees (first_name, last_name);

-- Create a View
CREATE VIEW important_query AS
SELECT SUM(invoice_total) AS total_sales
FROM invoices;

-- ================================
-- Section 7: Stored Procedures
-- ================================

-- Create a Stored Procedure
CREATE PROCEDURE GetEmployeeDetails
AS
BEGIN
    SELECT first_name, last_name FROM employees;
END;

-- Stored Procedure with Parameters
CREATE PROCEDURE GetEmployeeByID
    @EmployeeID INT
AS
BEGIN
    SELECT * FROM employees WHERE id = @EmployeeID;
END;

-- ================================
-- Section 8: Triggers
-- ================================

-- Create a Trigger
CREATE TRIGGER EmployeeInsert
ON employees
AFTER INSERT
AS
BEGIN
    PRINT 'A new employee has been added.';
END;

-- ================================
-- Section 9: Transactions
-- ================================

-- Transactions Example
BEGIN TRANSACTION;
UPDATE employees SET salary = salary + 1000 WHERE id = 1;
COMMIT;

-- ================================
-- Section 10: T-SQL Specific Concepts
-- ================================

-- Control-of-Flow Statements
IF EXISTS (SELECT * FROM customers WHERE points > 1000)
BEGIN
    PRINT 'High-value customers exist.';
END
ELSE
BEGIN
    PRINT 'No high-value customers found.';
END;

-- Error Handling with TRY...CATCH
BEGIN TRY
    UPDATE orders SET order_date = NULL WHERE order_id = 1;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Dynamic SQL
DECLARE @sql NVARCHAR(MAX) = 'SELECT * FROM customers WHERE state = ''CA''';
EXEC sp_executesql @sql;

-- Temporary Tables
CREATE TABLE #TempTable (ID INT, Name VARCHAR(50));
INSERT INTO #TempTable VALUES (1, 'TempUser');
SELECT * FROM #TempTable;

-- Common Table Expressions (CTEs)
WITH SalesCTE AS (
    SELECT client_id, SUM(invoice_total) AS total_sales
    FROM invoices
    GROUP BY client_id
)
SELECT * FROM SalesCTE WHERE total_sales > 1000;

-- ================================
-- Section 11: Advanced SQL Concepts
-- ================================

-- Recursive Queries
WITH RecursiveCTE AS (
    SELECT employee_id, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.manager_id
    FROM employees e
    JOIN RecursiveCTE r ON e.manager_id = r.employee_id
)
SELECT * FROM RecursiveCTE;

-- PIVOT Example
SELECT *
FROM (
    SELECT product_id, year, sales
    FROM sales_data
) AS SourceTable
PIVOT (
    SUM(sales) FOR year IN ([2021], [2022])
) AS PivotTable;

-- Full-Text Search
SELECT * 
FROM documents 
WHERE CONTAINS(content, 'SQL');

-- JSON Functions
SELECT JSON_VALUE(data, '$.name') AS name
FROM customers;

-- XML Functions
SELECT *
FROM orders
WHERE xml_data.exist('/Order[CustomerID="123"]') = 1;

-- ================================
-- Section 12: Indexing and Optimization
-- ================================

-- Covering Index
CREATE NONCLUSTERED INDEX idx_covering
ON orders (order_date)
INCLUDE (customer_id, total_amount);

-- Execution Plan Analysis
SET STATISTICS TIME ON;
SELECT * FROM customers;

-- Partitioning
CREATE PARTITION FUNCTION myPartitionFunction (INT)
AS RANGE LEFT FOR VALUES (1, 100, 1000);

-- ================================
-- Section 13: Security and Permissions
-- ================================

-- Granting Permissions
GRANT SELECT ON customers TO user1;

-- Revoking Permissions
REVOKE SELECT ON customers FROM user1;

-- Row-Level Security
CREATE SECURITY POLICY SalesFilter
WITH (STATE = ON)
AS
ADD FILTER PREDICATE dbo.FilterPredicate(client_id)
ON dbo.invoices;

-- ================================
-- Section 14: Functions
-- ================================

-- User-Defined Function (UDF)
CREATE FUNCTION GetDiscountedPrice (@price DECIMAL, @discount DECIMAL)
RETURNS DECIMAL
AS
BEGIN
    RETURN @price - (@price * @discount / 100);
END;

-- Example Usage of Function
SELECT dbo.GetDiscountedPrice(100, 10) AS DiscountedPrice;

-- ================================
-- Section 15: Miscellaneous Concepts
-- ================================

-- Stored Generated Columns
ALTER TABLE customers
ADD full_name AS (first_name + ' ' + last_name);

-- Using EXISTS Instead of IN
SELECT customer_id
FROM customers
WHERE EXISTS (
    SELECT 1
    FROM orders
    WHERE customers.customer_id = orders.customer_id
);



-- ================================
-- Problems
-- ================================

-- Problem 1: Basic Query
-- Retrieve the names and email addresses of customers from the customers table 
-- who live in the state of 'CA'. Sort the results alphabetically by last_name.
SELECT first_name, last_name, email
FROM customers
WHERE state = 'CA'
ORDER BY last_name;

-- Problem 2: Aggregates and GROUP BY
-- Find the total number of orders and the average order amount for each customer. 
-- Only include customers who have placed more than 2 orders.
SELECT customer_id, COUNT(order_id) AS total_orders, AVG(order_total) AS avg_order_amount
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 2;

-- Problem 3: Joining Tables
-- Retrieve the names of customers and the names of products they ordered. 
-- Include only customers who have placed at least one order.
SELECT c.first_name, c.last_name, p.name AS product_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Problem 4: Subqueries
-- Find the names of customers who have spent more than the average total order amount across all customers.
SELECT first_name, last_name
FROM customers c
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(order_total) > (
        SELECT AVG(order_total)
        FROM orders
    )
);

-- Problem 5: T-SQL with CTE and Transactions
-- Create a stored procedure that increases the price of all products in a specific category by 10%.
-- The category name should be passed as a parameter.
CREATE PROCEDURE IncreaseProductPrices
    @CategoryName NVARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE p
        SET p.price = p.price * 1.10
        FROM products p
        JOIN categories c ON p.category_id = c.category_id
        WHERE c.name = @CategoryName;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

-- Usage Example:
EXEC IncreaseProductPrices @CategoryName = 'Electronics';

-- Bonus Problem: Recursive Query
-- Using a WITH clause, retrieve a hierarchy of employees starting from the CEO 
-- (who has manager_id = NULL). Display their name and level in the hierarchy.
WITH EmployeeHierarchy AS (
    SELECT employee_id, first_name, last_name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT first_name, last_name, level
FROM EmployeeHierarchy
ORDER BY level, first_name;
