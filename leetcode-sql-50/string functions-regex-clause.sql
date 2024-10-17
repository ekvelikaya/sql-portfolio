
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