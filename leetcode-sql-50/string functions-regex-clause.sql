
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