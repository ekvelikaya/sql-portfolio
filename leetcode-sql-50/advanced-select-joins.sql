-- For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
-- Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

SELECT manager.employee_id,
		 name,
		 reports_count,
		 average_age
FROM Employees emp
JOIN 
	(SELECT count(employee_id) AS reports_count,
		 reports_to AS employee_id,
		 round(avg(age)) AS average_age
	FROM Employees
	WHERE reports_to is NOT null
	GROUP BY  reports_to) AS Manager
ON emp.employee_id=manager.employee_id
ORDER BY  employee_id;

-- Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.
-- Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

SELECT employee_id,
		 department_id
FROM Employee
WHERE employee_id IN 
	(SELECT employee_id
	FROM Employee
	GROUP BY  employee_id
	HAVING COUNT(*) =1)
		OR primary_flag = 'Y';

