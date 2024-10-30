
--Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
--For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one.

DELETE
FROM Person
WHERE id IN 
	(SELECT p1.id
	FROM Person p1
	JOIN Person p2
		ON p1.email = p2.email
	WHERE p1.id > p2.id)

--Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null.

SELECT 
	(SELECT DISTINCT Salary
	FROM Employee
	ORDER BY  salary DESC limit 1 offset 1) AS SecondHighestSalary;

SELECT max(salary) AS SecondHighestSalary
FROM employee
WHERE salary <
	(SELECT max(salary)
	FROM employee);

-- Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.

SELECT 
    user_id, 
    CONCAT(upper(substring(name, 1, 1)), lower(substring(name, 2))) AS name
FROM 
    users
ORDER BY 
    user_id;

-- Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. 
-- Type I Diabetes always starts with DIAB1 prefix.

SELECT patient_id,
		 patient_name,
		 conditions
FROM Patients
WHERE conditions LIKE '% DIAB1%'
		OR conditions LIKE 'DIAB1%';

-- Write a solution to find for each date the number of different products sold and their names.
-- The sold products names for each date should be sorted lexicographically.
-- Return the result table ordered by sell_date.

SELECT sell_date, 
		COUNT(DISTINCT product) AS num_sold, 
		STRING_AGG(DISTINCT product, ',' ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

-- Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

SELECT product_name,
		 sum(unit) AS unit
FROM Orders
LEFT JOIN Products
	ON Orders.product_id=Products.product_id
WHERE date_part('year', order_date) = 2020
	  AND date_part('month', order_date) = 2
GROUP BY  product_name
HAVING sum(unit) >= 100;