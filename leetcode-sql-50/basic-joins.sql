
-- Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

SELECT unique_id,
	   name
FROM employees e
LEFT JOIN EmployeeUNI u
	ON e.id=u.id;

-- Write a solution to find the number of times each student attended each exam.

SELECT s.student_id,
		 s.student_name,
		 sub.subject_name,
		 COUNT(e.student_id) AS attended_exams
FROM Students AS s
CROSS JOIN Subjects AS sub
LEFT JOIN Examinations AS e
	ON s.student_id = e.student_id
		AND sub.subject_name = e.subject_name
GROUP BY  s.student_id, s.student_name, sub.subject_name
ORDER BY  s.student_id, sub.subject_name;

-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

SELECT customer_id,
		 count(visit_id) AS count_no_trans
FROM 
	(SELECT customer_id,
		 visit_id
	FROM visits
	WHERE visit_id NOT IN 
		(SELECT visit_id
		FROM Transactions)) t1
	GROUP BY  customer_id;

-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

SELECT p.product_name,
		 s.year,
		 s.price
FROM Sales s
LEFT JOIN Product p
	ON s.product_id=p.product_id;
    
-- There is a factory website that has several machines each running the same number of processes.
-- Write a solution to find the average time each machine takes to complete a process.
-- The time to complete a process is the 'end' timestamp minus the 'start' timestamp. 
-- The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
-- The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

with t1 AS 
	(SELECT machine_id,
		 process_id,
		 timestamp
	FROM Activity
	WHERE activity_type='start'), 
    t2 AS 
	(SELECT machine_id,
		 process_id,
		 timestamp
	FROM Activity
	WHERE activity_type='end')
    
SELECT t1.machine_id,
		 round(avg(t2.timestamp-t1.timestamp)::decimal,
		 3) AS processing_time
FROM t1
JOIN t2 using(machine_id)
GROUP BY  t1.machine_id;

-- Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

SELECT id
FROM 
	(SELECT id,
		 recorddate,
		 temperature,
		 lag(temperature) over(order by recorddate) AS prev_temp,
		 lag(recorddate) over(order by recorddate) AS prev_date
	FROM Weather ) t1
WHERE temperature>prev_temp
		AND (recorddate-prev_date) = 1

-- Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

SELECT name,
		 bonus
FROM Employee
LEFT JOIN bonus using(empId)
WHERE bonus < 1000
		OR bonus is NULL;


-- Write a solution to find managers with at least five direct reports.

SELECT name
FROM Employee
WHERE id IN 
	(SELECT managerid
	FROM Employee
	GROUP BY  managerid
	HAVING count(managerid)>= 5);


