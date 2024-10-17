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

