
-- Write a solution to calculate the number of unique subjects each teacher teaches in the university.

SELECT teacher_id,
		 count(distinct subject_id) AS cnt
FROM teacher
GROUP BY  teacher_id;

-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date <= DATE '2019-07-27' AND activity_date > DATE '2019-07-27' - INTERVAL '30 days'
GROUP BY activity_date;

-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold.

SELECT product_id,
		 year AS first_year,
		 quantity,
		 price
FROM sales
LEFT JOIN Product using(product_id)
WHERE (product_id, year) IN (SELECT product_id,
		                    min(year)
	                        FROM Sales
	                        GROUP BY  product_id);

