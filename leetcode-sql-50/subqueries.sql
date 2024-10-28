-- A company's executives are interested in seeing who earns the most money in each of the company's departments. 
-- A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
-- Write a solution to find the employees who are high earners in each of the departments.

with t1 AS 
	(SELECT e.id,
		 e.name AS Employee,
		 e.salary,
		 e.departmentId,
		 d.name AS Department,
		 dense_rank() over(partition by departmentId order by salary desc) AS d_rank
	FROM Employee e
	JOIN Department d
		ON e.departmentId=d.id)

SELECT Department,
		 Employee,
		 Salary
FROM t1
WHERE d_rank IN (1,2,3);

-- Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. 
-- When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.

SELECT employee_id
FROM Employees
WHERE salary<30000
	  AND manager_id NOT IN (SELECT employee_id
							 FROM employees)
ORDER BY  employee_id;