-- SELECT CLAUSE
SELECT * FROM sql_store.customers;

USE sql_store;
SELECT first_name 
FROM customers 
-- WHERE customer_id = 1 
ORDER BY first_name;

SELECT 
	first_name, 
    last_name, 
    points, 
    points % 10 + 100 AS "example factor",
    (points + 10) * 100 AS discount_factor
FROM customers;

UPDATE `sql_store`.`customers` SET `state` = 'GA' WHERE (`customer_id` = '1');
SELECT DISTINCT state 
FROM customers;

SELECT 
	name, 
    unit_price, 
    unit_price * 1.1 AS new_price
FROM products;

-- WHERE CLAUSE (>, >=, <, <=, =, !=, <>)
SELECT *
FROM customers
WHERE points > 3000;

SELECT *
FROM customers
WHERE state <> 'VA';

SELECT * 
FROM customers
WHERE birth_date > '1990_01_01';

SELECT *
FROM orders
WHERE order_date >= '2019-01-01';

-- SELECT CLAUSE
SELECT * FROM sql_store.customers;

USE sql_store;
SELECT first_name 
FROM customers 
-- WHERE customer_id = 1 
ORDER BY first_name;

SELECT 
	first_name, 
    last_name, 
    points, 
    points % 10 + 100 AS "example factor",
    (points + 10) * 100 AS discount_factor
FROM customers;

UPDATE `sql_store`.`customers` SET `state` = 'GA' WHERE (`customer_id` = '1');
SELECT DISTINCT state 
FROM customers;

SELECT 
	name, 
    unit_price, 
    unit_price * 1.1 AS new_price
FROM products;

-- WHERE CLAUSE (>, >=, <, <=, =, !=, <>)
SELECT *
FROM customers
WHERE points > 3000;

SELECT *
FROM customers
WHERE state <> 'VA';

SELECT * 
FROM customers
WHERE birth_date > '1990_01_01';

-- AND OR 
SELECT *
FROM customers
WHERE birth_date > '1990-01-01' OR points > 1000;

-- AND > OR 
SELECT * 
FROM customers
WHERE birth_date > '1990_01_01' OR points > 1000 AND state = 'VA';
-- same as birth_date > '1990_01_01' OR (points > 1000 AND state = 'VA');

-- NOT
SELECT *
FROM customers
WHERE NOT(birth_date > '1990-01-01' OR points > 1000);

SELECT *
FROM order_items
WHERE order_id = 6 AND quantity * unit_price > 30;

-- IN
SELECT *
FROM Customers
-- (correct) WHERE state = 'VA' OR state = 'FL' OR state = 'CO'
-- (wrong) WHERE state = 'VA' OR 'FL' OR 'CO'
WHERE state IN ('VA', 'FL', 'GA');

SELECT *
FROM Customers
WHERE state NOT IN ('VA', 'FL', 'GA');

SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- BETWEEN
SELECT * 
FROM customers
-- WHERE points >= 1000 AND points <= 3000
WHERE points BETWEEN 1000 AND 3000;

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-1-1';

-- LIKE
SELECT *
FROM customers
WHERE last_name LIKE 'b%';
-- WHERE last_name LIKE '%y%'

SELECT *
FROM customers
WHERE last_name LIKE '____y';
-- % any number of characters
-- _ single character

SELECT *
FROM customers
WHERE address LIKE '%trail%' OR 
	  address LIKE '%avenue%';

SELECT *
FROM customers
WHERE phone NOT LIKE '%9';

-- REGEXP
SELECT *
FROM customers
WHERE last_name REGEXP 'field';
-- start with field  '^field'
-- start with field 'field$'

SELECT *
FROM customers
WHERE last_name REGEXP 'field|mac|rose';

SELECT *
FROM customers
WHERE last_name REGEXP '[gim]e';

SELECT *
FROM customers
WHERE last_name REGEXP '[a-h]e';

SELECT *
FROM customers
-- WHERE first_name REGEXP 'ELKA|AMBUR'
-- WHERE last_name REGEXP 'EY$|ON$'
-- WHERE last_name REGEXP '^MY|SE';
WHERE last_name REGEXP 'b[ru]';

-- IS NULL
SELECT *
FROM customers 
WHERE phone IS NULL; 
-- WHERE phone IS NOT NULL;

SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- ORDER BY
SELECT *
FROM customers
ORDER BY first_name;

SELECT *
FROM customers
ORDER BY first_name DESC;

SELECT *
FROM customers
ORDER BY state DESC, first_name;

SELECT last_name
FROM customers
ORDER BY points;

SELECT first_name, last_name, 10 AS ALIAS
FROM customers
ORDER BY points;

SELECT first_name, last_name, points
FROM customers
ORDER BY 1, 3; -- not a good implementation

SELECT *, (quantity * unit_price) AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- LIMIT
SELECT *
FROM customers
LIMIT 3;

SELECT *
FROM customers
LIMIT 6,3; -- skip first 6, then print first 3 

SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- (INNER) JOIN
SELECT order_id, first_name, last_name, orders.customer_id -- explicitly declare the table name
FROM orders
JOIN customers
	ON orders.customer_id = customers.customer_id;
    
SELECT order_id, p.product_id, name, quantity, oi.unit_price
FROM order_items oi
JOIN products p
	ON p.product_id = oi.product_id;
    
-- ALIAS
SELECT order_id, first_name, last_name, o.customer_id -- explicitly declare the table name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
    
-- JOIN ACROSS DATABASE
SELECT * 
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;
    
-- SELF JOINS
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name AS Employee,
    m.first_name AS Manager
FROM employees e
JOIN employees m -- use diff alias
	ON e.reports_to = m.employee_id;
    
-- JOIN MULTIPLE TABLES
USE sql_store;

SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;

USE sql_invoicing;
SELECT 
	c.name, 
    p.date, 
    p.amount, 
    pm.name AS payment_method
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	ON p.payment_id = pm.payment_method_id;


-- Compound join condition
	USE sql_store;
    SELECT *
    FROM order_items oi
    JOIN order_item_notes oin
		ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id;

-- IMPLICIT JOIN (not recommended)
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id; 

-- if miss WHERE clause, will be cross join
SELECT *
FROM orders o, customers c;

-- OUTER JOIN
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
RIGHT JOIN customers c -- LEFT (OUTER) JOIN is Preffered.
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id;
    
-- OUTER JOIN AMONG MULTIPLE TABLES
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o 
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

SELECT 
	o.order_id,
    o.order_date,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_statuses os
	ON o.status = os.order_status_id;
    
-- SELF OUTER JOIN
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- USING
USE sql_store;

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	USING (customer_id) -- using is only avialable when two col names are identical
LEFT JOIN shippers sh
	USING (shipper_id);
    
SELECT *
FROM order_items oi
LEFT JOIN order_item_notes oin
	USING (order_id, product_id);

USE sql_invoicing;
SELECT 
	p.date,
    c.name AS client,
    p.amount,
    pm.name AS payment
FROM payments p
LEFT JOIN clients c USING (client_id)
LEFT JOIN payment_methods pm 
	ON p.payment_method = pm.payment_method_id; 

-- NATURAL JOIN (not recommended, unexpected result)
USE sql_store;
SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- CROSS JOIN
SELECT 
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
-- (same) FROM customers c, products p
ORDER BY c.first_name;

-- UNION
SELECT first_name
FROM customers
UNION 
SELECT name
FROM shippers;

SELECT 
	order_id,
    order_date,
    'ACTIVE' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
	order_id,
    order_date,
    'ARCHIVED' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'BRONZE' AS type
FROM customers c
WHERE points <= 1000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'SLIVER' AS type
FROM customers c
-- WHERE points > 1000 AND points <= 2000
WHERE points BETWEEN 1000 AND 2000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    'GOLD' AS type
FROM customers c
WHERE points > 2000
ORDER BY first_name;

-- INSERT NEW ROW TO TABLE
INSERT INTO customers
VALUES (
	DEFAULT,
    'John',
    'Smith',
    '1990-01-01',
    NULL,
    'a',
    'b',
    'c',
    DEFAULT);
    
INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
VALUES (
    'Cathy',
    'Weng',
    '1998-06-01',
    'd',
    'f',
    'c');
    
-- INSERT MULTIPLE ROWS
INSERT INTO shippers (name)
VALUES('shipper1'),
	 ('shipper2'),
     ('shipper3');

-- INSERT HIERARCHICAL ROWS
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.96),
    (LAST_INSERT_ID(), 2, 2, 3.98);
    
-- CREATE A COPY OF A TABLE
CREATE TABLE orders_archived AS
SELECT * FROM orders;

USE sql_Store;
INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

USE sql_invoicing;
CREATE TABLE exercise AS
SELECT 
	i.number,
    c.name,
    i.payment_date
FROM invoices i
JOIN clients c USING (client_id)
WHERE i.payment_dateexercise IS NOT NULL;

-- UPDATE SINGLE ROW
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'
WHERE invoice_id = 1;

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE invoice_id = 3;

-- UPDATE MULTIPLE ROWS
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN (3, 4, 5);

USE sql_store;
UPDATE customers
SET points = points + 50
WHERE birth_date > '1990-01-01';

-- USE subquery in updates
USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.4,
    payment_date = due_date
WHERE client_id = 
		(SELECT client_id
			FROM clients
            WHERE name = 'MyWorks');

UPDATE invoices
SET 
	payment_total = invoice_total * 0.4,
    payment_date = due_date
WHERE client_id IN 
		(SELECT client_id
			FROM clients
            WHERE state IN ('NY', 'CA'));
            
USE sql_store;
UPDATE orders
SET 
	comments = "GOLD MEMBER"
WHERE customer_id IN
		(SELECT customer_id
			FROM customers
            WHERE points > 3000);
            
-- DELETE
USE sql_invoicing;
DELETE FROM invoices
WHERE client_id =
		(SELECT client_id
        FROM clients
        WHERE name = "MyWorks");